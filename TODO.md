# TODO — Correções e Melhorias do Projeto ZRP

Relatório gerado em: 12/10/2026

Análise feita a partir da leitura do código atual (Rails 8, React, Socket.IO, Sneakers,
gRPC/Gruf, Action Cable, devcontainer). Não foram usados TODOs antigos como fonte de
verdade: cada item abaixo foi re-verificado no código/estado atual do repositório.

**Legenda**
- Severidade: `[CRÍTICO]` `[ALTO]` `[MÉDIO]` `[BAIXO]`
- Subsystema: `[Backend]` `[gRPC]` `[Cable/SSE]` `[Sneakers]` `[Socket.IO]` `[React]` `[Infra]` `[Testes]`
- `(VN)` = precisa verificação em runtime antes de corrigir.

---

## Sumário

- [Ações Imediatas](#ações-imediatas)
- [Crítico](#crítico)
- [Alto](#alto)
- [Médio](#médio)
- [Baixo](#baixo)
- [O Que Já Está OK](#o-que-já-está-ok)

---

## Ações Imediatas

Ordem sugerida para atacar primeiro (impacto x urgência):

1. **Rotacionar e remover segredos do git** — `RAILS_MASTER_KEY`, `MEILI_MASTER_KEY`, token gRPC e senhas estão commitados.
2. **Fechar o Resque Web** (`/jobs`) — sem autenticação, permite enfileirar jobs arbitrários (RCE).
3. **Corrigir o cálculo de score da batalha** — `rank.to_i` sempre retorna `0`, a lógica de rank não funciona.
4. **Corrigir o boot de produção** — `rswag` só existe em dev/test mas é montado em produção; e produção usa SQLite com schema PostgreSQL.
5. **Parar o loop quente de realocação** — `resource_not_allocated` reenfileira o job imediatamente, sem intervalo nem limite.
6. **Corrigir a recursão infinita do Socket.IO server** — sem caso base e com o client nunca respondendo ao ACK.

---

## Crítico

- [ ] **[CRÍTICO][Infra] Segredos versionados no repositório**
  `git ls-files` confirma que estão rastreados: `.devcontainer/.env` (`RAILS_MASTER_KEY`, `PGADMIN_DEFAULT_PASSWORD`, `MEILI_MASTER_KEY`, `DB_PASSWORD`), `sneakers/.env` (`GRUF_AUTH_TOKEN=austin`) e `react/.env.development`. Além disso `.devcontainer/rabbitmq/definitions.json` traz `guest/guest` como admin.
  O `.gitignore` **não** possui regra para `.env`.
  **Correção:** `git rm --cached` desses arquivos; adicionar `.env`, `.env.*` (com `!.env.example`) ao `.gitignore`; remover do histórico (`git filter-repo`); **rotacionar** master key, `MEILI_MASTER_KEY`, token gRPC, senhas de pgAdmin/RabbitMQ; criar `.env.example` com placeholders e injetar segredos via secrets do devcontainer/CI.

- [ ] **[CRÍTICO][Backend] Score da batalha ignora o rank dos heróis e ameaças**
  `app/use_cases/allocate_resource/domain_service/calculator/battle.rb:35-36`
  ```ruby
  option :nv, ..., default: -> { hero.rank.to_i }
  option :nc, ..., default: -> { threat.rank.to_i }
  ```
  Os enums retornam a **label string** (`enum :rank, { c: 0, ... }`), então `"c".to_i == 0` e `"god".to_i == 0`. Logo `nv == nc == 0` sempre, e `n = 100 - ratio*(nv-nc).abs` vira sempre `100`. O rank é ignorado no cálculo.
  **Correção:** usar o valor inteiro do enum: `AllocateResource::Model::Hero.ranks.fetch(hero.rank)` (idem `Threat`), ou `hero[:rank]`/`rank_before_type_cast`. Revisar os `Types::Strict::Integer.constrained(gteq: 0)` de `n`/`d`, que podem passar a violar o limite após a correção.

- [ ] **[CRÍTICO][Infra] Boot de produção quebrado — `rswag` em produção**
  `config/routes.rb:4-5` monta `Rswag::Ui::Engine`/`Rswag::Api::Engine` e os initializers `rswag_api.rb`/`rswag_ui.rb` os referenciam, mas `rswag`/`rswag-specs` estão em `group :development, :test` (`Gemfile:115-116`). Em produção `Bundler.require` não carrega o gem → `NameError` ao carregar rotas/initializers.
  **Correção:** mover `rswag` para o grupo default **ou** proteger os mounts/initializers com `if Rails.env.development? || Rails.env.test?`.

- [ ] **[CRÍTICO][Infra] Produção usa SQLite com schema PostgreSQL**
  `config/database.yml:29-31` (`production: <<: *sqlite`) enquanto dev/test usam PostgreSQL. O `db/schema.rb` usa recursos exclusivos do Postgres (`enable_extension "pg_catalog.plpgsql"`, `jsonb`, `uuid`, `bigserial`). Além disso o código depende de lock de linha (`FOR UPDATE SKIP LOCKED`).
  **Correção:** apontar `production` para o anchor `*postgresql` (variáveis `DB_*`). Se SQLite for realmente desejado, o schema/estratégia de lock precisa ser revisto.

- [ ] **[CRÍTICO][Backend] Resque Web exposto sem autenticação em `/jobs`**
  `config/routes.rb:6` — `mount Resque::Server, at: '/jobs'`. Sem basic-auth, qualquer um lista/reenfileira/descarta jobs e pode enfileirar classes+argumentos arbitrários (caminho conhecido para RCE).
  **Correção:** proteger com `Rack::Auth::Basic` (ou equivalente) e/ou montar apenas em development.

- [ ] **[CRÍTICO][Backend] Loop quente de realocação quando não há herói compatível**
  `app/use_cases/allocate_resource/container.rb:77` publica `resource_not_allocated`, e `app/subscribers/resource_not_allocated/subscriber.rb:13` reenfileira `AllocateResource::Job.perform_later(threat.id)` **imediatamente, sem delay e sem limite**. O job roda de novo, não acha match, republica e reenfileira — loop sem fim que satura workers/fila.
  **Correção:** adicionar backoff + teto de tentativas (`set(wait: 1.minute)` com contador em Redis, ou `retry_on` com `attempts:`); ao esgotar, registrar/marcar a ameaça.

- [ ] **[CRÍTICO][Socket.IO] Recursão infinita de `emitOccurrence` sem caso base**
  `socket.io/server/index.js:33-35` — no erro/ACK-timeout chama a si mesma sem limite nem backoff, e o client (`socket.io/client/index.js:36-38`) **nunca chama o callback de ACK**, então todo emit expira e a recursão nunca para (mesmo após `disconnect`).
  **Correção:** limite de tentativas (`MAX_RETRIES`) + backoff + checagem `if (!socket.connected) return`; limpar no `socket.on('disconnect')`; e/ou fazer o client responder ao ACK. Tratar rejeições (`await ... .catch(...)`).

---

## Alto

- [ ] **[ALTO][Backend] Contracts HTTP nunca são executados (validação morta)**
  `app/services/http/application_service.rb:10` — `if defined?(self::Contract)`. Os contracts são **irmãos** do service (ex.: `Http::DestroyHero::Contract` vs `Http::DestroyHero::Service`), não aninhados sob ele, então a checagem é sempre `nil`. Resultado: a validação de `search` (regex/`query`/`page`), o `id: integer` do destroy e o `page` do threats-history não rodam — e `GET /v1/heroes/search` repassa `filter`/`sort` arbitrários ao Meilisearch.
  **Correção:** resolver o nome pelo namespace (`"#{self.name.deconstantize}::Contract".safe_constantize`) ou definir `Service::Contract`. Adicionar specs que afirmem que o contract é aplicado.

- [ ] **[ALTO][Cable/SSE] Action Cable sem autenticação e com stream único compartilhado**
  `app/channels/application_cable/connection.rb:8` fixa `self.token = 'token'`; `app/channels/notification_channel.rb:4-6` faz `reject if token.nil?` (inalcançável) e `stream_from(token)` — todos os clientes recebem as mesmas notificações.
  **Correção:** identificar o usuário (cookie assinado/JWT) e separar o stream (`"notifications:#{current_user.id}"`). Reescrever as specs de channel/connection (hoje testam `'token' == 'token'`).

- [ ] **[ALTO][Backend] Ausência total de autenticação/autorização nas rotas REST**
  Não há filtro de auth em `ApiController`/`ApplicationController`. Qualquer cliente cria/edita/remove heróis (`heroes_controller.rb`) e escreve estado global via `threats_controller.rb:12-14` (`set_insurgency` faz `params[:insurgency].to_i * 1000` sem validar presença/faixa e com `expires_in: nil`).
  **Correção:** implementar autenticação (SSO/Keycloak já era previsto) + autorização; validar `insurgency` (presença e faixa) antes de gravar no Redis.

- [ ] **[ALTO][Backend] `rescue_from StandardError` genérico esconde erros e retorna status errado**
  `app/controllers/api_controller.rb:4`, `app/services/http/application_service.rb:16-19` (`Rails.logger.info(args)` loga params completos), e `show_hero/service.rb:10`, `search_heroes/service.rb:9`, `dashboard/service.rb:9` (`raise StandardError, res.exception`). Todo `RecordNotFound` vira 500, então `ApplicationController#not_found` fica inalcançável e `GET /v1/heroes/:id` inexistente retorna 500 em vez de 404.
  **Correção:** deixar erros de domínio propagarem para o handler 404; mapear falhas conhecidas para 4xx; só capturar inesperados no nível externo; não logar params crus.

- [ ] **[ALTO][Backend] Jobs com retry sem limite (deallocate / remove_from_index)**
  `app/jobs/deallocate_resource/job.rb:14-17` reenfileira a si mesmo sem teto e com retry imediato; `app/jobs/remove_from_index/job.rb:12` reenfileira a cada 5s indefinidamente. Um id permanentemente inválido entra em loop.
  **Correção:** `retry_on` com `attempts:`/`wait:` ou contador em Redis; ao esgotar, logar e publicar evento de falha (dead-letter).

- [ ] **[ALTO][Backend] Índices ausentes em colunas de consulta quente**
  `db/schema.rb`: `battles` só tem índice em `score`; sem índice em `hero_id`, `threat_id`, `finished_at`, `created_at`. `threats` sem índice em `status`/`created_at`. `heroes` sem índice em `status`/`updated_at`.
  Usados por `Scopes::Battle::Fresh`, `Scopes::Threat::Fresh`, dashboard (`includes(:battles).where('battles.finished_at'...)`) e `threats_history` (`.order 'battles.finished_at desc'`).
  **Correção:** adicionar índices (`battles(hero_id)`, `battles(threat_id)`, `battles(finished_at)`, `threats(created_at)`, `threats(status)`, `heroes(status)`) — idealmente `concurrently` em produção.

- [ ] **[ALTO][Sneakers] Dead-letter quebrado — mensagens são acked e perdidas**
  `sneakers/processor.rb:46-48` — `dead_exchange` usa `channel.exchange(...)`, mas `Sneakers::Worker` **não define `channel`** (só `queue`, que expõe `channel`). Isso levanta `NoMethodError`, capturado pelo `rescue` de `dead!` (linhas 41-43) que chama `ack!` — ou seja, JSON inválido e mensagens com retry esgotado são descartadas silenciosamente.
  **Correção:** usar `queue.channel.exchange(...)` (ou `queue.exchange`); no rescue, preferir `reject!`/nack sem requeue em vez de `ack!`. Adicionar spec que verifique a publicação no exchange.

- [ ] **[ALTO][gRPC] Token de auth com fallback hardcoded e nome de env divergente**
  `config/initializers/gruf.rb:17` — `ENV.fetch('GRPC_AUTH_TOKEN', 'austin')` (fallback fraco); `sneakers/processor.rb:75` lê `ENV.fetch('GRUF_AUTH_TOKEN')` (nome diferente). Configurar um lado quebra o outro.
  **Correção:** unificar o nome (ex.: `GRPC_AUTH_TOKEN`) nos dois lados, exigir `fetch` sem default (falhar rápido em produção), rotacionar o token.

- [ ] **[ALTO][Backend] Adapter de Active Job de produção não configurado**
  `config/environments/production.rb:59` está comentado (`# config.active_job.queue_adapter = :resque`), enquanto development usa `:resque` (`development.rb:87`). Com `perform_later` espalhado pelo app, em produção os jobs caem no adapter default e não chegam aos workers Resque.
  **Correção:** definir `config.active_job.queue_adapter = :resque` em produção (ou no `application.rb`), garantindo também o backend de unicidade correto.

- [ ] **[ALTO][Backend] Ambiente de development contraditório (sem reload, com eager load)**
  `config/environments/development.rb:20` (`enable_reloading = true`) seguido de `:29` (`config.cache_classes = true`) — `cache_classes` sobrescreve e desliga o reload; e `:32` (`eager_load = true`) força eager load em dev.
  **Correção:** remover `config.cache_classes` e definir `config.eager_load = false`.

- [ ] **[ALTO][Infra] Sem CI e `.github` está no `.gitignore`**
  `.gitignore:44` ignora `/.github`, portanto não há workflow. `rspec`, `rubocop` e `brakeman` nunca rodam automaticamente; `config/environments/test.rb` só faz eager load quando `ENV["CI"]` existe (nunca, na prática).
  **Correção:** remover a regra `/.github` e adicionar workflow rodando `bundle exec rspec`, `rubocop` e `brakeman`.

- [ ] **[ALTO][Socket.IO] Client perde mensagens e abre conexão AMQP por evento**
  `socket.io/client/index.js:6-26` — abre conexão+canal TCP a cada ocorrência, ignora o retorno de `sendToQueue`, não usa publisher confirms nem `persistent: true`, e em erro só faz `console.warn` (sem retry). `channel.close()` não está no `finally`.
  **Correção:** conexão/canal persistentes e reutilizados, `confirmSelect()` + `waitForConfirms()`, publicar `{ persistent: true }`, retry com backoff, `finally` fechando o canal e shutdown gracioso.

- [ ] **[ALTO][React] Tabela de heróis fica no skeleton para sempre quando a busca falha**
  `react/src/heroes/actions.js:10-16` dispara `HEROES_LOADING` (`loading: true`) e só `HEROES_FETCHED` (que zera `loading`) no sucesso. Em erro, apenas `handle_errors(e)` → `List.js:65-66` renderiza `<Placeholder.Graph active />` indefinidamente.
  **Correção:** no `catch`, despachar um estado de falha que resete `loading` e mostre mensagem/retry.

- [ ] **[ALTO][React] Payload do SSE entra no store sem validação**
  `react/src/dashboard/actions.js:22-31` — `JSON.parse(event.data)` vira `{ type: eventType, payload }`. O **nome** do evento é whitelisted (`action_types.js`), mas o payload não: o servidor controla o conteúdo dos slices (inclusive formatos que quebram componentes, ex.: `BattlesCharts` espera `[[label, value], ...]`).
  **Correção:** validar o payload por tipo (schema/guards) antes de despachar; em divergência, logar e descartar.

- [ ] **[ALTO][React] Três requisições idênticas de `ranks` ao abrir a página**
  `react/src/heroes/Filter.js:15`, `Searcher.js:47` e `List.js:140` (via `HeroForm.js:71`) chamam `get_ranks()` quando `ranks.length === 0`; como a primeira resposta ainda não chegou, disparam em paralelo.
  **Correção:** buscar `ranks` uma única vez (no parent `Heroes.js`) ou usar flag de "em andamento"/RTK Query.

- [ ] **[ALTO][Infra] Sem `.dockerignore`; secrets e `node_modules` vão para a imagem**
  `.devcontainer/Dockerfile:46` faz `COPY . .` sem `.dockerignore`, copiando `.git`, `react/node_modules`, `react/coverage` e `.devcontainer/.env` (segredos) para a imagem, além de invalidar cache a cada mudança.
  **Correção:** criar `.dockerignore` (`.git`, `node_modules`, `coverage`, `tmp`, `log`, `**/.env`, ...) e reordenar `COPY Gemfile* ./` + `bundle install` antes de `COPY . .`.

---

## Médio

- [ ] **[MÉDIO][Backend] Médias do dashboard: numerador limitado a 1000 hits, denominador = `totalHits`**
  `app/use_cases/dashboard/widgets/average_score/monad.rb:8-22` e `average_time_to_match/monad.rb:9-23`. Quando há mais de 1000 batalhas na janela, a média fica subestimada; também há risco de divisão por zero (`NaN`/`Infinity`, engolido pelo `Try`).
  **Correção:** usar stats/facets do Meilisearch ou a mesma janela nos dois lados, com guarda para `totalHits.zero?`.

- [ ] **[MÉDIO][Backend] Contract de AlertReceives muta `values` durante a validação**
  `app/use_cases/alert_receives/un/contract.rb:14-30` faz `values[:payload] = values.data.to_json`, `values.delete :monsterName`, move `location.*`. Mutação em rules é frágil e depende de ordem.
  **Correção:** validar no contract e normalizar em um step dedicado do transaction.

- [ ] **[MÉDIO][Backend] `model.create` não-bang mascara falha de persistência**
  `app/use_cases/alert_receives/un/container.rb:24` — `model.create(res.to_h)`. Em falha, um registro não persistido segue para `Notify`/resposta gRPC como se fosse sucesso.
  **Correção:** usar `create!` (deixar o transaction tratar) ou checar `persisted?`.

- [ ] **[MÉDIO][Backend] `try ... catch: StandardError` em transactions esconde bugs**
  `app/use_cases/create/transaction.rb:7`, `update/transaction.rb:8`, `allocate_resource/transaction.rb:7,9`. Converte `NoMethodError`/erros de tipo em falha de step.
  **Correção:** capturar apenas exceções de domínio esperadas (`RecordInvalid`, `RecordNotFound`, erros próprios).

- [ ] **[MÉDIO][Backend] `Delete` adquire lock fora de transação**
  `app/use_cases/delete/hero/container.rb:18` — `lock('FOR UPDATE SKIP LOCKED')` roda sem `ApplicationRecord.transaction` em volta; o lock é liberado imediatamente e não protege o `destroy!`.
  **Correção:** envolver o fluxo em transação (ou remover o lock enganoso).

- [ ] **[MÉDIO][Backend] Serializer de `ThreatsHistory` frágil e sem limite de página**
  `app/services/http/threats_history/serializer.rb:13-21` chama `object.battles.first` para `duration`/`finished_at`/`created_at` sem guarda de `nil` (ameaça sem batalha quebra); `per_page` não é limitado.
  **Correção:** guardar batalhas vazias e limitar `per_page` a um máximo.

- [ ] **[MÉDIO][Backend] Publicação no Rails Event Store com JSON string**
  `app/subscribers/*/subscriber.rb` (`resource_allocated:21`, `resource_deallocated:15`, `resource_not_allocated:15-16`, `hero_removed_from_index:13`) passam `...to_json` como `data`. Com `JSONClient` isso gera payload duplamente serializado.
  **Correção:** publicar Hash e deixar o client serializar.

- [ ] **[MÉDIO][Backend] Limpeza do registry global do Dry::Events a cada `to_prepare`**
  `config/initializers/dry_events.rb:18-24` faz `Dry::Events::Publisher.registry.clear`, o que apaga registros de qualquer outro publisher; e o wiring de subscribers em initializer contorna o loader.
  **Correção:** registrar sem limpar o registry global e mover o wiring para um boot step adequado.

- [ ] **[MÉDIO][Backend] `require` relativo ao CWD**
  `lib/rpc/UN/service.rb:7` (`require './lib/rpc'`) e `config/initializers/gruf.rb:9` (`require './lib/rpc/UN/service'`) quebram se o processo iniciar de outro diretório (workers, `cable/`, rake).
  **Correção:** `require_relative` ou autoload via Zeitwerk (`lib` já está em `autoload_lib`).

- [ ] **[MÉDIO][Backend] Múltiplas classes por arquivo / services dentro de jobs**
  `app/jobs/allocate_resource/job.rb:3-20` + `:22-25`, `deallocate_resource/job.rb`, `remove_from_index/job.rb` e `app/use_cases/alert_receives/un/container.rb:12-32` violam a convenção "uma classe por arquivo".
  **Correção:** extrair services para `app/use_cases/**/service.rb` e steps para `steps/`.

- [ ] **[MÉDIO][Backend] Modelos ActiveRecord duplicados para as mesmas tabelas**
  ~9 `Hero`, ~6 `Threat`, ~4 `Battle` espalhados em `app/use_cases/*/model(s)/**`, cada um com includes/concerns diferentes (`acts_as_paranoid`, AASM vs enum, Meilisearch, associações), fazendo o comportamento divergir por call site.
  **Correção:** modelos canônicos `Hero`/`Threat`/`Battle` + concerns/scopes por contexto; manter wrappers só quando necessário.

- [ ] **[MÉDIO][Infra] Branch de cache do development está invertido**
  `config/environments/development.rb:42-56` — se `tmp/caching-dev.txt` **existe** usa `:memory_store`; se **não** existe ativa `perform_caching` com Redis (o oposto do padrão Rails `dev:cache`).
  **Correção:** inverter (caching ligado apenas quando o arquivo existir) ou tornar a intenção explícita.

- [ ] **[MÉDIO][Infra] `seeds.rb` depende de FactoryBot (gem de dev/test)**
  `db/seeds.rb:11` — `FactoryBot.create_list(...)`; em produção `rails db:seed` levanta `NameError`.
  **Correção:** usar criação via models puros nos seeds.

- [ ] **[MÉDIO][Infra] Initializer do Meilisearch quebra o boot sem env (inclusive test)**
  `config/initializers/meilisearch.rb:4-5` — `ENV.fetch('MEILI_URL')`/`ENV.fetch('MEILI_MASTER_KEY')` em todos os ambientes; `bundle exec rspec` falha com `KeyError` se as variáveis não existirem.
  **Correção:** default para dev/test ou pular a config em `test`.

- [ ] **[MÉDIO][Infra] Logger do Resque fixo em DEBUG**
  `config/initializers/resque.rb:5` — `Resque.logger.level = Logger::DEBUG` em todos os ambientes.
  **Correção:** `ENV.fetch('RESQUE_LOG_LEVEL', 'info')`.

- [ ] **[MÉDIO][Infra] Action Cable apontando para host inexistente e processo desligado**
  `config/environments/development.rb:108` (`ws://cable:28080`), `Procfile:4` (processo `cable` comentado), `react/.env.development` (`REACT_APP_CABLE_URL` não referenciado). Não existe serviço `cable` no compose; a porta 28080 é publicada sem uso.
  **Correção:** subir o processo cable e apontar para o host/porta corretos, ou remover a config morta.

- [ ] **[MÉDIO][Infra] Regex de origem do Action Cable inválida + `hosts.clear`**
  `config/environments/development.rb:109` — `[%r{http://*}, %r{https://*}, nil]` (o `*` se aplica à barra, não ao esquema) e `:113` `config.hosts.clear`.
  **Correção:** `[%r{\Ahttps?://}]` (ou allowlist explícita) e manter o host authorization.

- [ ] **[MÉDIO][Socket.IO] Server sem CORS/auth/TLS, sem error handling e sem shutdown**
  `socket.io/server/index.js:17` (`new Server({})` sem CORS), ausência de auth e de handlers de `connection_error`/erro; `:6-8` top-level `await redis.connect()` sem try/catch; `console.log` para erros; `io.listen(3003)` sem handler de `error`; sem handlers de `SIGTERM`/`SIGINT`. Lê o Redis (`insurgency_time()`) a cada emit (`:12-15, :32`).
  **Correção:** CORS allowlist + auth token, loggers estruturados, try/catch e retry na conexão Redis, cachear `INSURGENCY_TIME`, shutdown gracioso, bind/handler explícitos.

- [ ] **[MÉDIO][Sneakers] Heartbeat 5s e contador de retry persistente**
  `sneakers/config.rb:17` — `heartbeat: 5` (bem abaixo do default 30) causa reconexões espúrias. `sneakers/processor.rb:60-67` — `clear_retry_count` só roda no sucesso; após dead-letter a chave persiste 1h e uma mensagem idêntica é tratada como esgotada.
  **Correção:** voltar heartbeat ao default; apagar a chave de retry ao fazer dead-letter.

- [ ] **[MÉDIO][Infra] `docker-compose` com lacunas**
  `.devcontainer/docker-compose.yml`: `api` sem `depends_on`/healthcheck para db/redis/meilisearch; `socket.io.server` sem `depends_on: redis`; `RAILS_LOG_LEVEL` presente no `.env` mas não repassado ao `api`; imagens `getmeili/meilisearch:latest` e `dpage/pgadmin4` sem pin; sem `deploy.resources.limits`.
  **Correção:** adicionar `depends_on`/healthchecks, repassar env vars, pinar imagens, definir limites.

- [ ] **[MÉDIO][Infra] `ALLOW_EMPTY_PASSWORD` é no-op na imagem oficial do Redis**
  `.devcontainer/docker-compose.yml:22-27` — variável é do Bitnami; a imagem `redis:alpine` a ignora.
  **Correção:** remover a variável ou usar `command: redis-server --requirepass ...`.

- [ ] **[MÉDIO][Infra] Makefile acopla `exec`/`test` ao `build`, sem `.PHONY`**
  `Makefile:1-12` — `exec: build` e `test: build` reexecutam `npm install -g @devcontainers/cli` + `devcontainer up` sempre; `test` chama `rspec` sem `bundle exec`. Sem `.PHONY`.
  **Correção:** separar `up` de `build`, `.PHONY`, e usar `bundle exec rspec`.

- [ ] **[MÉDIO][Infra] SimpleCov sem threshold e iniciado após o boot da app**
  `spec/rails_helper.rb:7,12-15` — `SimpleCov.start` depois de `require config/environment` (não cobre o boot) e sem `minimum_coverage`; `formatter` único (Tailwind).
  **Correção:** iniciar antes do environment, definir `minimum_coverage`/`minimum_coverage_by_file`, usar `MultiFormatter`.

- [ ] **[MÉDIO][Infra] `parallel_tests` instalado mas inutilizável**
  `Gemfile:112` + `bin/parallel_*` existem, mas não há `.parallel_*` nem `TEST_ENV_NUMBER` em `config/database.yml:25-27`.
  **Correção:** configurar bancos por worker e wire no task, ou remover o gem.

- [ ] **[MÉDIO][Infra] RuboCop inconsistente**
  `.rubocop.yml` não herda `rubocop-rails-omakase` (presente no `Gemfile:118`) nem registra `rubocop-inflector` (`Gemfile:127`); vários cops de Lint/Metrics estão desligados (`Lint/EmptyBlock`, `Lint/MissingSuper`, `Metrics/BlockLength`, etc.).
  **Correção:** herdar o omakase (ou remover o gem), registrar o inflector e reativar cops incrementalmente.

- [ ] **[MÉDIO][Infra] Migration `add_lock_version` não é segura em tabela cheia**
  `db/migrate/20251025152201_add_lock_version.rb:3-4` — `add_column ... default: 0, null: false` reescreve/locka `heroes`/`threats`.
  **Correção:** adicionar nulável, backfill em lotes, depois `SET NOT NULL` + default (ou `strong_migrations`).

- [ ] **[MÉDIO][Infra] `LD_PRELOAD` do jemalloc é x86_64-only; `BUNDLE_JOBS=$(nproc)` não é expandido**
  `.devcontainer/Dockerfile:27` usa caminho `/usr/lib/x86_64-linux-gnu/...` (quebra em arm64); `:11` — Dockerfile `ENV` não faz substituição de comando, então `$(nproc)` fica literal.
  **Correção:** resolver o path do jemalloc dinamicamente por arch; `RUN BUNDLE_JOBS=$(nproc) bundle install` (shell) ou `ARG`/`ENV` fixo.

- [ ] **[MÉDIO][Infra] `.devcontainer` roda como root e instala script remoto sem pin**
  `devcontainer.json:4` — `"remoteUser": "root"`; `Dockerfile:29` — `wget ... | sh` como root.
  **Correção:** criar usuário não-root, definir `remoteUser`; pinar o commit/instalar via pacote.

- [ ] **[MÉDIO][Infra] `filter_parameter_logging` incompleto**
  `config/initializers/filter_parameter_logging.rb:8-12` — sem `:authorization` (Bearer vai para o log), `:api_key`, `:credit_card`.
  **Correção:** adicionar esses filtros.

- [ ] **[MÉDIO][Infra] `clear_tests_log` roda Rake no boot**
  `config/initializers/clear_tests_log.rb:3-4` — carrega todas as Rake tasks e invoca `log:clear` no boot (frágil com Spring/paralelo).
  **Correção:** mover para um hook de setup de teste.

- [ ] **[MÉDIO][React] `SET_INSURGENCY` não tem case no reducer (ação descartada)**
  `react/src/dashboard/actions.js:68-73` despacha `SET_INSURGENCY`, mas `reducer.js:16-70` não trata (o teste em `reducer.test.js:93-98` documenta o pass-through). O valor do servidor é ignorado.
  **Correção:** adicionar o case/estado, ou remover o dispatch se for apenas fire-and-forget.

- [ ] **[MÉDIO][React] Slider reescreve o valor default no servidor a cada load**
  `react/src/navbar/InsurgencySlider.js:9-13` — o `useEffect` de mount (após 1s) dispara `set_insurgency(20)` sem ler o valor atual; falta `dispatch` nas deps.
  **Correção:** hidratar via GET inicial e só postar após mudança do usuário.

- [ ] **[MÉDIO][React] Buscas sem debounce/cancelamento → respostas fora de ordem**
  `react/src/heroes/Paginate.js:14-16` + `actions.js:8-18` — cada mudança de `query`/`filter`/`sort` dispara `search()` e aplica a resposta sem checar ordem.
  **Correção:** `AbortController` por request (ignorar respostas obsoletas) e debounce.

- [ ] **[MÉDIO][React] Tabela histórica refeita a cada mudança de `count` via SSE**
  `react/src/dashboard/HistoricalThreats.js:151,155-161` depende de `state.metrics.threats_disabled.count`; cada push re-busca 50 linhas.
  **Correção:** não usar `count` como gatilho; atualizar no mount/ação do usuário (ou throttle).

- [ ] **[MÉDIO][React] `console.error` não guardado no caminho SSE**
  `react/src/dashboard/actions.js:26-29` — o helper `log()` é guardado por env, mas o `catch` do `JSON.parse` chama `console.error` direto.
  **Correção:** passar pelo `log()`/guard.

- [ ] **[MÉDIO][React] Artefatos de coverage commitados**
  `git ls-files` lista 45 arquivos em `react/coverage/**` (desatualizados). O `.gitignore` só ignora `/coverage` na raiz.
  **Correção:** adicionar `react/coverage/` ao `.gitignore` e `git rm -r --cached react/coverage`.

- [ ] **[MÉDIO][React] Overlay de erro do webpack escondido via CSS**
  `react/src/index.css:1` — `iframe#webpack-dev-server-client-overlay{display:none!important}` esconde erros de dev.
  **Correção:** remover a regra e resolver os erros de base.

- [ ] **[MÉDIO][React] Middleware redundante/incorreto; `redux-multi` é morto**
  `react/src/index.js:7,20-25` — `thunk` adicionado duas vezes (já vem no `getDefaultMiddleware`) e `redux-multi` em posição errada, sem nenhum `dispatch([...])` no código.
  **Correção:** remover `multi`/`thunk` explícitos e a dependência `redux-multi`.

- [ ] **[MÉDIO][React] UI de ordenação dessincronizada do estado Redux**
  `react/src/heroes/List.js:24-30` — ao mudar `query`/`filter` limpa o sort local, mas o `search.sort` do store permanece.
  **Correção:** despachar reset de sort junto com a limpeza local.

---

## Baixo

- [ ] **[BAIXO][React] `reportWebVitals(console.log)` em produção** (`react/src/index.js:47`) — guardar por `NODE_ENV` ou no-op em produção.
- [ ] **[BAIXO][React] `exact` é prop morta no React Router v6** (`react/src/Routes.js:8-9,17`) — remover.
- [ ] **[BAIXO][React] `Duration` trunca inteiros apesar de pedir 2 decimais** (`react/src/dashboard/HistoricalThreats.js:38-48`) — `~~Number(x).toFixed(2)` volta a inteiro; formatar explicitamente.
- [ ] **[BAIXO][React] `Heroes` assume 1–2 heróis e pode quebrar** (`HistoricalThreats.js:105-125,134-147`) — guardar `heroes?.length` e mapear em vez de indexar `heroes[0]`/`heroes[1]`. `(VN)`
- [ ] **[BAIXO][React] `handle_errors` engole `response.data` em formato objeto** (`react/src/handleErrors.js:5-15`) — adicionar fallback serializando o objeto.
- [ ] **[BAIXO][React] Deps faltando em hooks** (`HeroForm.js:63-72`, `Paginate.js:14-16`, `InsurgencySlider.js:10-13`) — incluir `dispatch`/valores estáveis ou memoizar.
- [ ] **[BAIXO][React] Config morta `REACT_APP_CABLE_URL`** (`react/.env.development:4`) — remover.
- [ ] **[BAIXO][React] Dependências não usadas / bloat** (`react/package.json`) — `moment`, `react-widgets`, `react-bootstrap`, `styled-components`, `@fortawesome/*`, `react-actioncable-provider`, `redux-multi`, `"start": "^5.1.0"`, `typescript`/`@types/react` sem `tsconfig`. Podar.
- [ ] **[BAIXO][React] Boilerplate do CRA nos assets** (`react/public/index.html:8-11,27`, `react/src/logo.svg`) — título/description reais; apagar `logo.svg`.
- [ ] **[BAIXO][React] Nomenclatura inconsistente** — `handleErrors.js` vs `handle_errors.test.js`, `action_types.js`, `reportWebVitals.test.js` vs `ErrorBoundary.test.js`. Padronizar.
- [ ] **[BAIXO][React] PropTypes parcial** (`Dashboard.js`, `Heroes.js`, `Paginate.js`, `NavBar.js`) — completar ou migrar para TS.
- [ ] **[BAIXO][React] Mutações não ajustam `totalHits`** (`react/src/heroes/reducer.js:60-75`) — incrementar/decrementar em create/destroy.
- [ ] **[BAIXO][React] Acesso frágil a `aria-expanded`** (`react/src/heroes/Filter.js:42-49`) — usar o `eventKey` do rsuite. `(VN)`
- [ ] **[BAIXO][React] `search` não retorna a promise** (`react/src/heroes/actions.js:8-18`) — `return axios.get(...)` para consistência.
- [ ] **[BAIXO][Backend] Código morto / não referenciado** — `app/services/http/dashboard/service.rb` (só usado por rake), `app/controllers/base_controller.rb` (vazio), `app/controllers/application_controller.rb#not_found` (inalcançável), `app/models/concerns/scopes/battle/fresh.rb` (incluído e não usado).
- [ ] **[BAIXO][Backend] SSE sem heartbeat e sem erro no client** (`app/controllers/sse/widgets_controller.rb:5-14`, `sse/application_controller.rb:8,13`) — emitir heartbeat periódico e sinalizar erro/fechar o stream.
- [ ] **[BAIXO][Backend] Tipos/arities inconsistentes** — `job.rb:7` usa `Types::Coercible::Integer` vs `Types::Integer` em `deallocate`; services retornam tuplas de 2 vs 3 elementos em falha.
- [ ] **[BAIXO][Backend] `FINISHER` como constante global de initializer** (`config/initializers/finisher.rb:3-8`) — mover a regra para o use case (injetável).
- [ ] **[BAIXO][Backend] Timeouts agressivos do Meilisearch** (`config/initializers/meilisearch.rb:7-8`; `config/redis.yml:6-7` com `read/write_timeout: 1`) — revisar por ambiente.
- [ ] **[BAIXO][Backend] `page: 0` enviado ao Meilisearch** (`dashboard/widgets/*/monad.rb`) — páginas são 1-based; usar `page: 1`.
- [ ] **[BAIXO][Backend] SQL por interpolação** (`lib/tasks/kill_pg_connections.rake:9-13`) — usar bind parameter (hoje não é input de usuário, mas é padrão ruim).
- [ ] **[BAIXO][Infra] CORS aberto** (`config/initializers/cors.rb:10-17`) — restringir origens por env.
- [ ] **[BAIXO][Infra] Swagger vazio e links errados no README** (`swagger/v1/swagger.yaml` com `paths: {}`; `README.md:17` aponta `/api_docs` mas a rota é `/api-docs`) — regenerar/ignorar e corrigir links.
- [ ] **[BAIXO][Infra] `db/initdb/01_create_test_db.sql` hardcoded** — `CREATE DATABASE test` desconecta de `DB_TEST`/`DB_USERNAME` se mudarem.
- [ ] **[BAIXO][Infra] Prod `force_ssl`/`assume_ssl` sem exclusão de health check** (`config/environments/production.rb:30,33`) — confirmar que `/up` não entra em loop de redirect. `(VN)`
- [ ] **[BAIXO][Testes] Higiene de specs** — `spec/rails_helper.rb:41` usa `fixture_paths` como String (esperado Array); factories com `rand`/`Faker::Name.unique` (não determinísticas, sem `UniqueGenerator.clear`); `spec/spec_helper.rb` com `order = :random` comentado; `factory_bot` define classes top-level `Hero`/`Threat`/`Battle` em factories. `(VN)`
- [ ] **[BAIXO][Testes] Specs fracas/vazias** — `react/src/__tests__/ErrorBoundary.test.js` (não testa reset), `reportWebVitals.test.js` (terceiro teste sem assertion), `heroes/__tests__/Searcher.test.js`/`Filter.test.js`/`Paginate.test.js` (assertions condicionais/inexistentes), `HistoricalThreats.test.js` (expansão sem checar conteúdo).

---

## O Que Já Está OK

Verificado no código atual (evita retrabalho):

- ✅ Redux usa `configureStore` corretamente (o bug antigo de `applyMiddleware` + `configureStore` foi resolvido).
- ✅ `console.log` da Redis URL removido; `ActionCableProvider` foi substituído por SSE.
- ✅ `useEffect` duplicado do `Paginate` unificado; `INITIAL_STATE` tem `page`/`hitsPerPage`.
- ✅ `handle_errors` reescrito sem a regex destrutiva.
- ✅ `require('lodash')` migrado para `import`; `toLocaleLowerCase` → `toLowerCase`.
- ✅ Sneakers já tem DLX/TTL nas definições, `prefetch: 10`, e usa `Sneakers.logger` (não `puts`); gRPC client com `timeout: 10`.
- ✅ `resque.rb` usa guard para `config_for(:redis)` ausente.
- ✅ Versões consistentes: `.ruby-version` = `Gemfile` = Dockerfile = compose (`3.4.2`).
- ✅ `config.ru` segue o padrão do Rails (`run` + `load_server`).

### Itens que precisam de verificação em runtime (`(VN)`)

- Comportamento de lock (`FOR UPDATE SKIP LOCKED`) sob SQLite (relacionado ao CRÍTICO de DB).
- `config.cache_classes` no Rails 8 (confirmar se é no-op/deprecado) — o sintoma de reload já é claro.
- Alcance do RabbitMQ `guest` entre containers (a política padrão restringe a localhost).
- Descritor gRPC `:Handle` em `spec/services/rpc/alert_receives/un/service_spec.rb:14` (o proto define `rpc :Alert`).
- `fixture_paths` como String no `rails_helper.rb`.
