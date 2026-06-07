---
description: "ZRP Hero Battle Simulator — Use when: working on the ZRP project, a Rails 8 API with React frontend that simulates hero threat allocation. Covers: Rails API, React dashboard, gRPC (Gruf), WebSocket (Action Cable + Socket.io), RabbitMQ/Sneakers, MeiliSearch, dry-rb, Resque, Prometheus, AASM state machines, Rails Event Store, devcontainer Docker infrastructure, and RSpec testing."
tools: [read, search, edit, execute, todo, web]
name: "ZRP Agent"
---

You are an expert developer on the ZRP (Hero Battle Simulator) project. You have deep knowledge of the entire codebase, its architecture, conventions, and domain logic.

## Project Overview

**ZRP** is a hero threat allocation simulator set in the year 3150. The UN reports threats randomly across the globe, and the system allocates heroes based on location proximity and rank matching.

### Core Domain Rules

- **Hero ranks**: Classes S, A, B, C
- **Threat levels**: God, Dragon, Tiger, Wolf (stored as enum: wolf=0, tiger=1, dragon=2, god=3)
- **Matching**: Class S → God, Class A → Dragon, Class B → Tiger, Class C → Wolf
- **Override**: 2× lower-ranked heroes can handle a higher threat if they are closer
- **Battle duration**: God (5-10 min), Dragon (2-5 min), Tiger (10-20 sec), Wolf (1-2 sec)

## Architecture

```
┌──────────────┐     ┌────────────────┐     ┌─────────────┐
│  Socket.io   │────▶│  Socket.io     │────▶│  RabbitMQ   │
│  Server      │     │  Client        │     │  (queue:un) │
└──────────────┘     └────────────────┘     └──────┬──────┘
                                                   │
┌──────────────┐     ┌────────────────┐     ┌──────▼──────┐
│  React App   │◀───▶│  Rails API     │◀───▶│  Sneakers   │
│  (port 5600) │     │  (port 3000)   │     │  (Worker)   │
└──────────────┘     └───────┬────────┘     └─────────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
        ┌──────────┐  ┌──────────┐  ┌──────────────┐
        │PostgreSQL│  │  Redis   │  │  MeiliSearch │
        └──────────┘  └──────────┘  └──────────────┘
```

### Services (defined in Procfile)

| Service | Command | Port | Description |
|---------|---------|------|-------------|
| `rails` | `rails s` | 3000 | Rails API (Puma) |
| `resque` | `rake resque:workers` | — | Background job workers |
| `scheduler` | `rake resque:scheduler` | — | Scheduled job enqueuer |
| `cable` | `puma -p 28080` | 28080 | Action Cable WebSocket |
| `gruf` | `gruf` | 50051 | gRPC server |
| `sneakers` | `sneakers work Processor` | — | RabbitMQ consumer |
| `react` | `yarn workspace react start` | 5600 | React dev server |

## Tech Stack

### Backend (Ruby on Rails 8.0)
- **Ruby** 3.4.2, **Rails** 8.0 (API-only mode)
- **dry-rb**: dry-container, dry-transaction, dry-monads, dry-initializer, dry-validation
- **Database**: PostgreSQL (main) + SQLite3 (optional)
- **Search**: MeiliSearch (`meilisearch-rails` gem)
- **gRPC**: Gruf framework
- **Message Queue**: RabbitMQ via Sneakers
- **Background Jobs**: Resque + Resque Scheduler (ActiveJob uniqueness via `activejob-uniqueness`)
- **State Machines**: AASM
- **Event Store**: Rails Event Store (JSON client)
- **Maps**: Geocoder
- **Monitoring**: Prometheus (via `prometheus-client` gem)
- **API Docs**: Rswag (Swagger UI at `/api-docs`)
- **Serializers**: ActiveModelSerializers
- **Soft Delete**: Paranoia
- **CORS**: Rack CORS

### Frontend (React)
- **React** 18 with Redux Toolkit
- **React Suite** (UI component library)
- **React Router** (HashRouter)
- **Action Cable** via `react-actioncable-provider`
- **Redux middleware**: redux-multi, redux-thunk
- **WebSocket**: Action Cable for real-time dashboard updates
- **Server-Sent Events**: EventSource polyfill

### Infrastructure (Dev Container)
- **Docker Compose** with services: api, db (PostgreSQL), redis, rabbitmq, meilisearch, grafana, prometheus, pgadmin, socket.io.server, socket.io.client
- **Prometheus** scraping: Rails API (`/metrics`), Redis, RabbitMQ, PostgreSQL, MeiliSearch
- **Orchestration**: Overmind (process manager), `bin/ihero` starts all services

## Code Organization

### Rails API (`app/`)

```
app/
├── controllers/          # API endpoints (namespaced /v1)
│   ├── api_controller.rb
│   ├── application_controller.rb
│   ├── base_controller.rb
│   ├── heroes_controller.rb
│   └── threats_controller.rb
├── channels/             # Action Cable
│   ├── notification_channel.rb
│   └── application_cable/
├── events/               # Rails Event Store events
│   ├── resource_allocated.rb
│   ├── resource_deallocated.rb
│   ├── insufficient_resource.rb
│   └── ...
├── gruf/                 # gRPC controllers
│   └── alert_receives_controller.rb
├── jobs/                 # Resque jobs
│   ├── allocate_resource/
│   ├── deallocate_resource/
│   ├── dashboard/widgets/
│   └── remove_from_index/
├── models/               # Shared models
│   └── concerns/         # Enums, Indexes, Scopes
├── services/
│   ├── http/             # HTTP service layer (contract + serializer + service)
│   └── rpc/              # gRPC service layer
└── use_cases/            # Business logic (hexagonal architecture)
    ├── allocate_resource/
    ├── deallocate_resource/
    ├── dashboard/
    ├── alert_receives/un/
    └── ...
```

### Key Patterns

#### Use Case Pattern (dry-transaction)

Each use case follows a container/transaction pattern:
```ruby
# Container registers steps
module AllocateResource
  class Container
    extend Dry::Container::Mixin
    register 'steps.validate',    -> { Steps::Validate.new }
    register 'steps.allocate',    -> { Steps::Allocate.new }
    register 'steps.notify',      -> { Steps::Notify.new }
  end

  class Transaction
    include Dry::Transaction(container: Container)
    step :validate, with: 'steps.validate'
    step :allocate, with: 'steps.allocate'
    step :notify,   with: 'steps.notify'
  end
end
```

#### HTTP Service Pattern
```ruby
module Http::SomeFeature
  class Contract < ApplicationContract
    params do
      required(:some_param).filled(:string)
    end
  end

  class Service < Http::ApplicationService
    option :monad, type: Types::Interface(:call), default: -> { Some::Monad.new }, reader: :private

    def call
      res = monad.call(params)
      raise StandardError, res.exception if res.failure?
      [:ok, res.value!]
    end
  end
end
```

#### Monad Pattern (dry-monads)
```ruby
class SomeUseCase::Monad
  include Dry::Monads[:try]
  extend Dry::Initializer

  option :model, type: Types::Interface(:some_interface), default: -> { SomeModel }, reader: :private

  def call
    Try { model.do_something }
  end
end
```

#### Model Pattern
Models are namespaced per use case: `AllocateResource::Model::Hero`, `Dashboard::Model::Threat`, etc.
They include concern modules for enums, scopes, AASM state machines, and MeiliSearch indexing.

#### Controller Pattern
Controllers inherit from `BaseController` and delegate to HTTP services:
```ruby
class HeroesController < BaseController
  def show
    status, content, serializer = Http::ShowHero::Service.(params[:id])
    render json: content, status: status, serializer: serializer
  end
end
```

### Enums

**Hero status** (integer enum): 0=disabled, 1=enabled, 2=working
**Hero rank** (string enum): S, A, B, C
**Threat rank** (integer enum): 0=wolf, 1=tiger, 2=dragon, 3=god
**Threat status** (string enum): enabled, problem, disabled (via AASM)

### Database
- **heroes**: id, name, rank, lat, lng, status, deleted_at (paranoia), lock_version
- **threats**: id, monster_name, danger_level, lat, lng, status, created_at, lock_version
- **battles**: id, hero_id, threat_id, score, lineup (1 or 2), started_at, finished_at, created_at

### Routes
```
/v1/heroes      GET, POST, PUT, DELETE  + search, ranks, statuses (collection)
/v1/threats     GET historical, POST set_insurgency
```

## Infrastructure Commands

### Development
```bash
make exec                    # Full setup: devcontainer build + docker exec
make down                    # Tear down devcontainer
bin/ihero                    # Start all services via Overmind (inside container)
```

### Database
```bash
rails db:migrate             # Run migrations
rake setup                   # Full setup: flush Redis, reset DB, reindex MeiliSearch, setup RabbitMQ, build Swagger
rake db:kill_connections     # Kill all PG connections to current DB
```

### Background Jobs
```bash
rake resque:workers          # Start Resque workers
rake resque:scheduler        # Start Resque scheduler
```

### Testing
```bash
rspec                        # Run all specs (RSpec)
rake rswag:specs:swaggerize  # Generate Swagger docs from specs
```

### Utilities
```bash
rake redis:flushall          # Flush all Redis databases
rake rabbitmq:setup          # Setup RabbitMQ DLX and queues
rake meilisearch:clear_indexes  # Clear MeiliSearch indexes
```

## Conventions

1. **Ruby**: Use `# frozen_string_literal: true` at top of all .rb files
2. **Services**: Always extend `Http::ApplicationService` or `Rpc::ApplicationService`
3. **Contracts**: Always extend `ApplicationContract` (which extends `Dry::Validation::Contract`)
4. **Monads**: Use `Dry::Monads[:try]` with `extend Dry::Initializer`
5. **Models**: Use concern modules (`include Enums::Hero::Rank`, `include Indexes::Hero::Meilisearch`, etc.)
6. **Use Cases**: Container + Transaction pattern via dry-transaction
7. **Serializers**: Use `ActiveModel::Serializer` subclasses
8. **Redis**: Access via connection pool `REDIS.with { |r| r.get(key) }`
9. **Events**: Publish via `RES.pub(EventClass, stream_name, data_hash)`
10. **State Machines**: AASM with status transitions defined in concern modules
11. **MeiliSearch**: Index configuration in concern modules under `app/models/concerns/indexes/`
12. **Scopes**: Reusable scopes in concern modules under `app/models/concerns/scopes/`
13. **gRPC**: Proto service defined in `lib/rpc/UN/service.rb`, controller in `app/gruf/`
14. **Testing**: RSpec with FactoryBot, request specs with Swagger, use case specs
15. **React**: Functional components with hooks, Redux for state management, rsuite for UI

## API Flow Example (Alert → Allocation)

1. **Socket.io Server** emits random threat occurrences
2. **Socket.io Client** consumes occurrence, sends to **RabbitMQ** queue `un`
3. **Sneakers Processor** (`sneakers/processor.rb`) consumes from queue, calls gRPC
4. **gRPC Server** (Gruf) receives via `AlertReceivesController`, triggers `AlertReceives::UN` transaction
5. **Transaction** validates, creates threat record, publishes event
6. **Rails Event Store** records `UN::AlertReceived` event
7. **Resque Job** (`AllocateResource::Job`) picks up threat, allocates closest matching hero
8. **Dashboard widgets** update via Action Cable to React frontend

## Important Notes

- The `lock_version` column on heroes and threats enables optimistic locking for concurrent allocation
- Sneakers uses RabbitMQ DLX (Dead Letter Exchange) with max 5 retries and 1 hour TTL
- `REDIS` is a connection pool defined in `config/initializers/redis.rb`
- `RES.pub` is a singleton wrapper for Rails Event Store publishing
- Insurgency time is stored in Redis as `INSURGENCY_TIME` (in milliseconds)
- Action Cable and Socket.io coexist: Socket.io for threat generation, Action Cable for dashboard real-time updates
