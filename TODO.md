# TODO - Análise e Melhorias do Projeto ZRP

Relatório gerado em: 05/06/2026

---

## Sumário

- [1. React Frontend](#1-react-frontend)
- [2. Rails API Backend](#2-rails-api-backend)
- [3. Servidor gRPC (Gruf)](#3-servidor-grpc-gruf)
- [4. Servidor WebSocket (Action Cable)](#4-servidor-websocket-action-cable)
- [5. RabbitMQ + Sneakers](#5-rabbitmq--sneakers)
- [6. Socket.io Server](#6-socketio-server)
- [7. Socket.io Client](#7-socketio-client)
- [8. Devcontainer + Infra](#8-devcontainer--infra)
- [Ações Imediatas](#ações-imediatas)

---

## 1. React Frontend

### CRÍTICO

- [x] **Corrigir store configuration do Redux Toolkit** (`react/src/index.js:23-31`)
  `applyMiddleware` + `configureStore` é incompatível. Usar API padrão do RTK:
  ```js
  const store = configureStore({
    reducer: reducers,
    middleware: (getDefaultMiddleware) =>
      getDefaultMiddleware().concat(thunk),
    devTools: process.env.NODE_ENV === 'development',
  });
  ```

- [ ] **Validar eventos do WebSocket antes de despachar como ação Redux** (`react/src/App.js:21-22`)
  `onReceived={e => dispatch(e)}` dá controle total do store ao servidor. Implementar whitelist/validação.

### ALTO

- [ ] **Remover console.log da Redis URL** (`react/src/index.js:32`)
  `console.log(process.env.REACT_APP_REDIS_URL)` vaza URL em produção.

- [ ] **Consolidar useEffect duplicados** (`react/src/heroes/paginate.js:14-15`)
  Duas chamadas de API no mount. Unificar em um único effect.

- [ ] **Adicionar page e hitsPerPage ao INITIAL_STATE** (`react/src/heroes/reducer.js:1-11`)
  Valores `undefined` no primeiro render causam comportamento imprevisível.

- [ ] **Corrigir regex destrutiva em handle_errors** (`react/src/handle_errors.js:11`)
  Regex remove dígitos e pontuação de mensagens de erro. Implementar extração estruturada.

- [ ] **Escrever testes significativos** (`react/src/App.test.js`)
  Único teste existente é boilerplate CRA. Testar componentes, reducers e actions.

### MÉDIO

- [ ] **Proteger console.logs em produção** (`react/src/App.js:23-26`)
  Envolver em `if (process.env.NODE_ENV === 'development')` ou remover.

- [ ] **Adicionar useMemo em dados computados** (`react/src/heroes/filter.js:51,54`, `react/src/heroes/hero_form.js:55`)
  `.reverse()` modifica array original a cada render. Usar `useMemo` + slice.

- [ ] **Adicionar array de dependências no useEffect** (`react/src/heroes/searcher.js:33`)
  `useEffect` sem dependências executa em todo render.

- [ ] **Debounce no slider de insurgency** (`react/src/navbar/insurgency_slider.js:10`)
  Dispara POST a cada movimento. Adicionar debounce de 300-500ms.

- [ ] **Separar close() do dispatch assíncrono** (`react/src/heroes/hero_form.js:46`)
  Modal fecha antes da resposta da API. Mover `close()` para callback de sucesso.

- [ ] **Trocar toLocaleLowerCase() por toLowerCase()** (`react/src/dashboard/threats_distribution.js:21`, `react/src/dashboard/heroes_distribution.js:20`)

### BAIXO

- [ ] Migrar `require('lodash')` para `import _ from 'lodash'`
- [ ] Adicionar PropTypes ou migrar para TypeScript
- [ ] Adicionar Error Boundaries
- [ ] Adicionar estados de loading e empty state
- [ ] Padronizar nome de arquivos (PascalCase para componentes)
- [ ] Padronizar uso de ponto e vírgula (ESLint + Prettier)
- [ ] Remover imports não utilizados (`useDispatch`, `useEffect`, `Slider`)
- [ ] Remover chaves numéricas em maps (usar `key` estável)
- [ ] Corrigir `reportWebVitals()` sem argumento (`react/src/index.js:56`)

---

## 2. Rails API Backend

### CRÍTICO

- [x] **Corrigir `render head:` inválido** (`app/controllers/application_controller.rb:9`)
  ```ruby
  # Errado:
  render head: :not_found
  # Correto:
  head :not_found
  ```
  Causa `ArgumentError` em qualquer requisição com registro não encontrado.

- [ ] **Restringir CORS** (`config/initializers/cors.rb:12`)
  `origins "*"` permite qualquer origem. Especificar origens permitidas.

### ALTO

- [ ] **Consolidar modelos de Hero duplicados** (`app/use_cases/*/model/*/hero.rb`)
  ~9 modelos diferentes para a mesma tabela. Criar um modelo único com scopes/concerns.

- [ ] **Extrair subscribers do initializer** (`config/initializers/dry_events.rb:23-65`)
  Lógica de aplicação misturada com configuração. Mover para service objects.

- [ ] **Refatorar dashboard widgets em job único parametrizado** (`app/jobs/dashboard/widgets/*/job.rb`)
  8 arquivos ~idênticos. Um único job com parâmetros.

- [ ] **Remover `debugger` do código de produção** (`app/services/http/application_service.rb:17`)

- [ ] **Adicionar autenticação HTTP** (`app/controllers/application_controller.rb:3`)
  API completamente aberta sem autenticação.

- [ ] **Corrigir database.yml** (`config/database.yml:30`)
  SQLite em produção e PostgreSQL em dev/test é inversão perigosa.

### MÉDIO

- [ ] **Restringir strong parameters** (`app/controllers/heroes_controller.rb:68,72`)
  `params.permit(:id, hero: {})` permite atributos aninhados arbitrários.

- [ ] **Remover `BaseController` vazio** (`app/controllers/base_controller.rb:3`)
  Nível extra desnecessário na hierarquia de controllers.

- [ ] **Trocar `rescue_from StandardError` genérico** (`app/controllers/api_controller.rb:4`)
  Resgatar apenas exceções específicas ou retornar detalhes no body.

- [ ] **Adicionar timeout no Redis.new** (`config/initializers/redis.rb:4-8`)
  `Redis.new(timeout: 5_000)` para evitar workers pendurados.

- [ ] **Reativar métricas do Rubocop** (`.rubocop.yml:100-125`)
  AbcSize, MethodLength, CyclomaticComplexity desabilitados.

- [ ] **Remover `connection_pool.with_connection` redundante** (`app/use_cases/alert_receives/un/container.rb:24`)
  ActiveRecord já gerencia connection pool.

- [ ] **Criar locale files para I18n.t()** (`app/use_cases/allocate_resource/container.rb:43`)
  Mensagens de erro usam I18n mas não há arquivos de locale visíveis.

### BAIXO

- [ ] Escrever testes para os 8 monads de dashboard widget
- [ ] Escrever testes para os 7 serviços HTTP
- [ ] Escrever testes para subscribers de eventos
- [ ] Escrever testes para rotas de erro dos controllers
- [ ] Padronizar tratamento de falhas nos services (raise vs monad)

---

## 3. Servidor gRPC (Gruf)

### ALTO

- [ ] **Versionar arquivo .proto original** (`lib/rpc.rb`)
  Só existe o binário compilado. O `.proto` original está perdido. Adicionar ao repositório com Rake task de compilação.

- [ ] **Trocar StandardError genérico por exceções de domínio** (`app/services/rpc/alert_receives/UN/service.rb:13`)
  Usar classes específicas (e.g., `ValidationFailedError`) e mapper para status codes gRPC.

- [ ] **Corrigir expectativa de teste** (`spec/rpc/alert_receives_controller_spec.rb:44-45`)
  Teste espera `ArgumentError` mas service levanta `StandardError`. Verificar e corrigir.

### MÉDIO

- [ ] **Trocar require relativo por require_relative** (`lib/rpc/UN/service.rb:9`)
  `require './lib/rpc'` depende do working directory.

- [ ] **Remover fallback hardcoded do token** (`config/initializers/gruf.rb:17`)
  `ENV.fetch('GRPC_AUTH_TOKEN', 'austin')` -- levantar erro se não configurado em produção.

- [ ] **Extrair steps inline para arquivos próprios** (`app/use_cases/alert_receives/un/container.rb:12-32`)
  Violação da convenção "um arquivo por classe".

- [ ] **Tornar .to_h explícito** (`app/gruf/alert_receives_controller.rb:7`)
  `request.message.to_h` em vez de depender de conversão implícita.

- [ ] **Configurar binding_url via env var** (`config/initializers/gruf.rb:12`)
  `0.0.0.0:50051` hardcoded.

### BAIXO

- [ ] Adicionar testes de contrato unitários para `Contract`
- [ ] Adicionar testes de autenticação gRPC
- [ ] Adicionar testes de integração (servidor gRPC real)
- [ ] Remover metadata `user_id` não utilizado
- [ ] Usar constantes para nomes de eventos (`'threat.created'`)

---

## 4. Servidor WebSocket (Action Cable)

### CRÍTICO

- [ ] **Implementar autenticação real na conexão** (`app/channels/application_cable/connection.rb:6`)
  `self.token = 'token'` é placeholder. Implementar verificação de JWT ou cookie assinado:
  ```ruby
  identified_by :current_user

  def connect
    self.current_user = find_verified_user
  end

  def find_verified_user
    if (token = request.params[:token])
      User.jwt_decode(token) || reject_unauthorized_connection
    else
      reject_unauthorized_connection
    end
  end
  ```

- [ ] **Separar streams por usuário** (`app/channels/notification_channel.rb:6`)
  `stream_from(token)` faz todos compartilharem o mesmo stream. Usar:
  ```ruby
  stream_from "notifications:#{current_user.id}"
  ```

### ALTO

- [ ] **Remover código morto** (`app/channels/notification_channel.rb:5`)
  `reject if token.nil?` nunca executa porque `token` é sempre a string `'token'`.

- [ ] **Reescrever testes de conexão** (`spec/channels/application_cable/connection_spec.rb`)
  Teste atual verifica `'token' == 'token'` -- zero valor. Testar JWTs válidos, inválidos e expirados.

- [ ] **Reescrever testes de channel** (`spec/channels/notification_channel_spec.rb`)
  Teste usa cenário `token: nil` que nunca ocorre. Testar `stream_from` correto e broadcasts.

### MÉDIO

- [ ] Adicionar shared behavior no `ApplicationCable::Channel` base
- [ ] Adicionar rate limiting de conexões WebSocket
- [ ] Adicionar logging de conexão/desconexão

---

## 5. RabbitMQ + Sneakers

### CRÍTICO

- [ ] **Tratar JSON inválido com reject! em vez de requeue!** (`sneakers/processor.rb:13,16`)
  `JSON.parse` em mensagem inválida entra em loop infinito de requeue:
  ```ruby
  rescue JSON::ParserError => error
    Sneakers.logger.error "Invalid JSON: #{error.message}"
    reject!
  ```

- [ ] **Corrigir ack! condicional** (`sneakers/processor.rb:15`)
  `ack!` só ocorre se gRPC retorna `Threat`. Outros retornos deixam mensagem presa:
  ```ruby
  result = client.(:Alert, occurrence)
  if result.message.is_a?(::Rpc::Threat)
    ack!
  else
    requeue!
  end
  ```

- [ ] **Trocar credenciais hardcoded guest/guest** (`sneakers/config.rb:9-10`)
  RabbitMQ 3.3+ rejeita guest de localhost remoto. Usar env vars:
  ```ruby
  username: ENV.fetch('RABBITMQ_USER'),
  password: ENV.fetch('RABBITMQ_PASS'),
  ```

### ALTO

- [ ] **Adicionar Dead Letter Exchange (DLX)** (`sneakers/config.rb`)
  Sem DLX, mensagens que sempre falham ficam em requeue infinito.

- [ ] **Trocar puts por logger** (`sneakers/processor.rb:17-18`)
  `puts` perde estruturação. Usar `Sneakers.logger.error`.

- [ ] **Adicionar timeout na chamada gRPC** (`sneakers/processor.rb:27-33`)
  Worker pode travar para sempre se servidor gRPC estiver fora.

- [ ] **Adicionar TTL na fila** -- sem limite de vida para mensagens.

### MÉDIO

- [ ] Remover fallback silencioso do `ENV.fetch('AMQP_SERVER', nil)`
- [ ] Adicionar `prefetch` e `heartbeat` explícitos na config
- [ ] Adicionar timeout de job (`timeout_job_after`)
- [ ] Adicionar mensagens persistentes no publisher (`{ persistent: true }`)
- [ ] Escrever testes para: happy path, JSON inválido, erro gRPC, falha Redis
- [ ] Usar logger em vez de `puts`

---

## 6. Socket.io Server

### CRÍTICO

- [ ] **Corrigir recursão infinita em emitOccurrence** (`socket.io/server/index.js:32-33`)
  Sem caso base: se cliente não responde ACK, chama a si mesma até stack overflow.
  ```js
  const MAX_RETRIES = 3;
  let retries = 0;

  function emitOccurrence(socket) {
    if (retries >= MAX_RETRIES) {
      socket.disconnect();
      return;
    }
    // ...
    socket.timeout(t).emit("occurrence", payload, (err) => {
      if (err) { retries++; emitOccurrence(socket); }
    });
  }
  ```

- [ ] **Adicionar timeout e retry na conexão Redis** (`socket.io/server/index.js:8-10`)
  `await` top-level sem timeout trava o processo se Redis estiver fora.

- [ ] **Adicionar TLS e autenticação** -- WebSocket em texto puro, sem CORS.

### ALTO

- [ ] **Adicionar graceful shutdown** (`socket.io/server/index.js`)
  Handlers `SIGTERM`/`SIGINT` para fechar IO e Redis.

- [ ] **Remover pacote `http: ^0.0.1-security`** (`socket.io/server/package.json:15`)
  Pacote malicioso conhecido do npm.

- [ ] **Adicionar error handling no socket** (`socket.io/server/index.js:38-40`)
  Handlers para `disconnect`, `error`, `connect_error`.

### MÉDIO

- [ ] Cachear `INSURGENCY_TIME` em memória em vez de ler Redis a cada emit
- [ ] Usar `console.error` em vez de `console.log` para erros
- [ ] Adicionar endpoint de health check (`/healthz`)

---

## 7. Socket.io Client

### CRÍTICO

- [ ] **Usar conexão AMQP persistente** (`socket.io/client/index.js:9-24`)
  Criar nova conexão TCP por evento é extremamente ineficiente:
  ```js
  let connection, channel;

  async function connect() {
    connection = await amqp.connect(process.env.AMQP_SERVER);
    channel = await connection.createChannel();
    await channel.assertQueue(queue, { durable: true });
  }
  ```

- [ ] **Aguardar confirmação do sendToQueue** (`socket.io/client/index.js:16`)
  Sem `await`, mensagens podem ser perdidas. Usar `await channel.waitForConfirms()`.

### ALTO

- [ ] **Adicionar retry com backoff** (`socket.io/client/index.js:19`)
  Erros são engolidos silenciosamente. Mensagens perdidas para sempre.

- [ ] **Fechar channel no finally** (`socket.io/client/index.js:12,22`)
  Vazamento: channel não é fechado em caso de erro no assertQueue.

- [ ] **Validar URL de conexão** (`socket.io/client/index.js:27`)
  Concatenação sem validação produz `"undefined:undefined"`.

- [ ] **Adicionar graceful shutdown** -- handlers SIGTERM/SIGINT.

- [ ] **Adicionar persistent: true** (`socket.io/client/index.js:16`)
  Mensagens não-persistentes são perdidas no restart do RabbitMQ.

### MÉDIO

- [ ] Corrigir `.env` com espaços ao redor do `=` (quebra parsers)
- [ ] Mover nome da fila para env var
- [ ] Adicionar testes (zero testes atualmente)

---

## 8. Devcontainer + Infra

### CRÍTICO

- [ ] **Adicionar .env ao .gitignore** (`.gitignore`)
  `RAILS_MASTER_KEY` e outros 10+ secrets estão versionados no git.

- [ ] **Rodar todos os secrets expostos**
  `RAILS_MASTER_KEY` (`ca484a78af6b7f925520ff57b6dcca4b`) descriptografa todas as credenciais Rails.

- [ ] **Trocar remoteUser de root para usuário não-root** (`devcontainer.json:4`)
  `"remoteUser": "root"` -- qualquer vulnerabilidade em gem/npm tem acesso root total.

### ALTO

- [ ] **Criar .dockerignore** (raiz do projeto)
  Sem ele, Docker envia `node_modules/`, `.git/`, `tmp/`, etc. para o daemon.
  ```
  node_modules/
  .git/
  tmp/
  log/
  coverage/
  .DS_Store
  ```

- [ ] **Reordenar COPY no Dockerfile** (`devcontainer/Dockerfile:43`)
  `COPY . .` antes do `bundle install` invalida cache de gems a cada mudança:
  ```dockerfile
  COPY Gemfile Gemfile.lock ./
  RUN bundle install
  COPY . .
  RUN yarn install
  ```

- [ ] **Usar imagem Node para serviços Socket.IO** (`docker-compose.yml:71-88`)
  Usam imagem Ruby (1GB+) quando precisam apenas de Node.js.

- [ ] **Adicionar env vars faltando no docker-compose**
  - `socket.io.client`: sem `SOCKET_IO_SERVER`, `SOCKET_IO_SERVER_PORT`
  - `socket.io.server`: sem `REDIS_URL`, `INSURGENCY_TIME`

### MÉDIO

- [ ] Adicionar `mem_limit`/`cpus` em todos os serviços (16 serviços sem limites)
- [ ] Remover portas desnecessárias expostas ao host
- [ ] Corrigir `BUNDLE_RETRY` duplicado com valores conflitantes (`Dockerfile:12,14`)
- [ ] Remover pacotes desnecessários (`tmux`, `openssh-client`, `lsb-release`)
- [ ] Mover extensões VS Code desnecessárias (duas de AI commit, language pack PT-BR)
- [ ] Adicionar volume persistente para Prometheus
- [ ] Adicionar provisioning para Grafana (datasources + dashboards)
- [ ] Corrigir Makefile: `exec` não deve depender de `build` (sempre reconstrói)
- [ ] Renomear processo `rails` para `web` no Procfile
- [ ] Adicionar `.PHONY` no Makefile

---

## Ações Imediatas

Prioridade máxima para correção imediata:

1. **Corrigir `render head:`** (`app/controllers/application_controller.rb:9`)
   Bug que crasha em qualquer 404. Deve ser `head :not_found`.

2. **Adicionar `.env` ao `.gitignore` e rodar secrets**
   `RAILS_MASTER_KEY` exposto no repositório. Criar `.env.example`.

3. **Corrigir store do Redux** (`react/src/index.js:23-31`)
   `configureStore` do RTK sendo usado incorretamente com `applyMiddleware`.

4. **Implementar autenticação no ActionCable** (`app/channels/application_cable/connection.rb:6`)
   Qualquer cliente pode conectar e receber todas as notificações.

5. **Adicionar Dead Letter Exchange no Sneakers** (`sneakers/config.rb`)
   Mensagens inválidas entram em loop infinito de requeue.

6. **Corrigir recursão infinita no Socket.io server** (`socket.io/server/index.js:32-33`)
   Stack overflow garantido se cliente não responde ACK.

7. **Usar conexão AMQP persistente no Socket.io client** (`socket.io/client/index.js:9-24`)
   Conexão por evento exaure descritores de arquivo sob carga.

8. **Adicionar env vars faltando no docker-compose**
   Serviços Socket.io não recebem variáveis necessárias para funcionar.
