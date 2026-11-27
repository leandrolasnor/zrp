# TODO

## Pendências

- [x] **[React] ThreatsDistribution: ranks sem ameaça não exibem o zero** — ✅ corrigido
  Quando não há threat de determinado rank, o badge mostra só o nome seguido de `:` (ex.: `Tiger:`). Exibir `Tiger: 0`.
  Causa provável: `app/use_cases/dashboard/widgets/threats_distribution/monad.rb:20` envia `dist[it]` = `nil` para ranks ausentes; `react/src/dashboard/ThreatsDistribution.js:21` renderiza o valor direto. Garantir o `0` (no payload e/ou no componente, ex.: `?? 0`).

- [x] **[React/Backend] BattlesCharts: label mostra sempre "100 Battles"**
  Exibir a quantidade real de batalhas em uma janela de tempo (padrão: últimos 20 min) no lugar do `100`, ex.: `37 Battles`.
  O `total` em `react/src/dashboard/BattlesCharts.js:12,31` hoje soma as porcentagens de `app/use_cases/dashboard/widgets/battles_lineup/monad.rb:22-23` (sempre 100). O search já filtra `created_at > 20.minutes.ago` e traz `totalHits` (`:11-19`) — incluir esse count no payload do widget e usá-lo no label (com guarda para `totalHits.zero?` nas porcentagens). Ajustar `react/src/dashboard/__tests__/Widgets.test.js:169`.

- [x] **[React] Legenda acima do RingProgress nos widgets do dashboard** — ✅ corrigido
  Título inserido logo acima do `RingProgress` em:
  - `react/src/dashboard/HeroesWorking.js` → `Heroes`
  - `react/src/dashboard/ThreatsDisabled.js` → `Threats`
  - `react/src/dashboard/BattlesCharts.js` → `Battles` (a legenda com a contagem usa `Resolved`)

- [x] **[Dev] Logs centralizados via Dozzle** — ✅ corrigido
  Loggers em arquivo (Rails/Bullet/Puma/Resque/Sneakers/socket.io) foram redirecionados para stdout/stderr; as configurações antigas de log em arquivo permanecem comentadas. Cada processo do Procfile virou um serviço do docker-compose (`api`/Puma, `resque`, `scheduler`, `gruf`, `sneakers`, `react`), todos com logs em stdout e visíveis no Dozzle (`make logs`, `http://localhost:8888`). `make exec` agora abre apenas um shell na api.

