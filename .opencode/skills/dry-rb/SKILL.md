---
name: dry-rb
description: Use quando precisar de informações sobre o ecossistema dry-rb, suas gems, documentação oficial, site, repositórios GitHub, ou exemplos de código. Ativa para perguntas sobre dry-validation, dry-types, dry-monads, dry-struct, dry-system, dry-operation, dry-initializer, dry-configurable, dry-cli, dry-logger, dry-inflector, dry-schema, dry-transformer, dry-auto_inject, dry-core, dry-effects, dry-events, dry-files, dry-logic, dry-matcher, dry-rails, dry-monitor, dry-view, dry-container, dry-transaction, Hanakai.
---

# Varredura do Site e Documentação do dry-rb

## Site oficial

**URL:** https://dry-rb.org (redireciona para https://hanakai.org/dry)

O dry-rb agora faz parte do guarda-chuva **Hanakai** (união de Hanami, Dry e Rom).

### Páginas principais

| Página | URL |
|--------|-----|
| Landing page Dry | https://hanakai.org/dry |
| Visão geral / Getting Started | https://hanakai.org/learn/dry/getting-started |
| Documentação completa | https://hanakai.org/learn/dry |
| Blog | https://hanakai.org/blog |
| Comunidade | https://hanakai.org/community |

### Repositórios GitHub

**Organização:** https://github.com/dry-rb

**Gems principais (estrelas ~jun/2026):**

| Gem | Descrição | Estrelas |
|-----|-----------|----------|
| dry-validation | Validação com schemas type-safe e regras | 1.4k |
| dry-types | Sistema de tipos flexível com coerções e restrições | 898 |
| dry-monads | Monads comuns em Ruby idiomático | 890 |
| dry-struct | Structs tipadas e objetos valor | 438 |
| dry-configurable | Mixin para classes configuráveis | 425 |
| dry-system | Container de DI com auto-registro (base do Hanami) | 371 |
| dry-cli | Framework CLI para Ruby | 354 |
| dry-initializer | DSL para construtores de classes | 341 |
| dry-logic | Lógica de predicados com composição de regras | 191 |
| dry-auto_inject | Injeção de dependência automática | 179 |
| dry-transformer | Toolkit de transformação de dados | 89 |
| dry-operation | DSL step-based para operações de negócio | 63 |
| dry-logger | Biblioteca de logging | 37 |

### Outros canais

- **Fórum:** https://discourse.hanakai.org
- **Discord:** https://discord.com/invite/KFCxDmk3JQ
- **Mastodon:** https://ruby.social/@hanakai
- **Bluesky:** https://bsky.app/profile/hanakai.org
- **Newsletter:** https://buttondown.com/hanakai
- **Código de conduta:** https://hanakai.org/conduct

---

## Mapa do Ecossistema dry-rb

A documentação oficial vive em `https://hanakai.org/learn/dry/<gem>/<versão>/<página>`.

### 1. Validação e Dados

#### dry-validation (v1.11)
- **Docs:** https://hanakai.org/learn/dry/dry-validation/v1.11/
- **Repo:** https://github.com/dry-rb/dry-validation
- **Uso:** Contratos de validação com schemas type-safe e regras
- **Tópicos:** Configuração, Schemas, Regras, Mensagens, Macros, Dependências externas, Extensões, Pattern matching
- **Exemplo:**
```ruby
class UserContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
    required(:age).filled(:integer)
  end

  rule(:age) { key.failure("must be greater than 18") if value < 18 }
end
```

#### dry-types (v1.8)
- **Docs:** https://hanakai.org/learn/dry/dry-types/v1.8/
- **Repo:** https://github.com/rb/dry-types
- **Uso:** Sistema de tipos com restrições, coerções, enums
- **Tópicos:** Tipos built-in, Optional, Default, Fallbacks, Constraints, Hash Schemas, Enum, Map, Custom Types, Extensions (Maybe, Monads)
- **Exemplo:**
```ruby
Types = Dry.Types(default: :strict)

module Types
  Email = String.constrained(format: /@/)
  UserRole = String.enum("admin", "member", "guest")
end
```

#### dry-schema (v1.14)
- **Docs:** https://hanakai.org/learn/dry/dry-schema/v1.14/
- **Repo:** https://github.com/rb/dry-schema
- **Uso:** Coerção e validação de estruturas de dados (base do dry-validation)
- **Tópicos:** Predicados built-in, Macros, Type specs, Params, JSON, Mensagens de erro, Extensões (Hints, Info, JSON Schema, Monads)

#### dry-struct (v1.8)
- **Docs:** https://hanakai.org/learn/dry/dry-struct/v1.8/
- **Repo:** https://github.com/rb/dry-struct
- **Uso:** Objetos valor tipados e imutáveis
- **Tópicos:** Structs aninhadas, Recipes
- **Exemplo:**
```ruby
class User < Dry::Struct
  attribute :email, Types::Email
  attribute :name, Types::String
  attribute :age, Types::Integer.constrained(gteq: 0)
  attribute :role, Types::UserRole
end
```

#### dry-initializer (v3.2)
- **Docs:** https://hanakai.org/learn/dry/dry-initializer/v3.2/
- **Repo:** https://github.com/rb/dry-initializer
- **Uso:** DSL para construtores com params e options
- **Tópicos:** Container Version, Params e Options, Type Constraints, Readers, Inheritance, Rails Support

#### dry-logic (v1.6)
- **Docs:** https://hanakai.org/learn/dry/dry-logic/v1.6/
- **Repo:** https://github.com/rb/dry-logic
- **Uso:** Predicados e regras composáveis (base do dry-validation/dry-schema)

### 2. Lógica de Negócio e Controle de Fluxo

#### dry-operation (v1.1)
- **Docs:** https://hanakai.org/learn/dry/dry-operation/v1.1/
- **Repo:** https://github.com/rb/dry-operation
- **Uso:** DSL step-based para operações de negócio com steps que retornam Success/Failure
- **Tópicos:** Error Handling, Configuração, Extensões, Design Pattern
- **Exemplo:**
```ruby
class CreateUser < Dry::Operation
  def call(input)
    attrs = step validate(input)
    user = step persist(attrs)
    step notify(user)
    user
  end
end
```

#### dry-monads (v1.8)
- **Docs:** https://hanakai.org/learn/dry/dry-monads/v1.8/
- **Repo:** https://github.com/rb/dry-monads
- **Uso:** Monads (Maybe, Result, Try, List, Task, Validated) para composição funcional
- **Tópicos:** Do notation, Pattern matching, Tracing failures, Unit

#### dry-effects (v0.5)
- **Docs:** https://hanakai.org/learn/dry/dry-effects/v0.5/
- **Repo:** https://github.com/rb/dry-effects
- **Uso:** Efeitos algébricos para gerenciar side effects
- **Tópicos:** Cache, Current Time, Defer, Environment, Interrupt, Parallel, Reader, Resolve (DI), State, Timeout

### 3. Utilidades do Dia a Dia

#### dry-configurable (v1.4)
- **Docs:** https://hanakai.org/learn/dry/dry-configurable/v1.4/
- **Repo:** https://github.com/rb/dry-configurable
- **Uso:** Mixin para configurar classes com type checking
- **Exemplo:**
```ruby
class CacheStore
  extend Dry::Configurable
  setting :backend, constructor: Types::String
  setting :ttl, default: 3600, constructor: Types::Integer
end
```

#### dry-logger (v1.2)
- **Docs:** https://hanakai.org/learn/dry/dry-logger/v1.2/
- **Repo:** https://github.com/rb/dry-logger
- **Uso:** Logging estruturado com formatters plugáveis
- **Tópicos:** Backends, Formatters, Templates, Filtering, Context, Tagging, Crash handling, Testing

#### dry-inflector (v1.2)
- **Docs:** https://hanakai.org/learn/dry/dry-inflector/v1.2/
- **Repo:** https://github.com/rb/dry-inflector
- **Uso:** Pluralização, singularização, conversão de casos

#### dry-core (v1.1)
- **Docs:** https://hanakai.org/learn/dry/dry-core/v1.1/
- **Repo:** https://github.com/rb/dry-core
- **Uso:** Utilitários compartilhados entre gems dry
- **Tópicos:** Cache, Container, Constants, Class Attributes, Class Builder, Deprecations, Equalizer, Extensions

#### dry-cli (v1.1)
- **Docs:** https://hanakai.org/learn/dry/dry-cli/v1.1/
- **Repo:** https://github.com/rb/dry-cli
- **Uso:** Framework para aplicações CLI
- **Tópicos:** Commands, Subcommands, Arguments, Options, Variadic arguments, Callbacks

#### dry-files (v1.1)
- **Docs:** https://hanakai.org/learn/dry/dry-files/v1.1/
- **Repo:** https://github.com/rb/dry-files
- **Uso:** Abstração de sistema de arquivos
- **Tópicos:** File System Utilities, Ruby File Manipulation, Adapters, Error Handling

#### dry-transformer (v1.1)
- **Docs:** https://hanakai.org/learn/dry/dry-transformer/v1.1/
- **Repo:** https://github.com/rb/dry-transformer
- **Uso:** Transformação de dados
- **Tópicos:** Transformation objects, Built-in transformations, Standalone functions

### 4. Arquitetura e Composição

#### dry-system (v1.2)
- **Docs:** https://hanakai.org/learn/dry/dry-system/v1.2/
- **Repo:** https://github.com/rb/dry-system
- **Uso:** Container de dependências com auto-registro (base do Hanami slices)
- **Tópicos:** Container, Component dirs, Providers, Auto-injection, Plugins, External provider sources, Settings, Test Mode
- **Exemplo:**
```ruby
class App < Dry::System::Container
  configure do |config|
    config.component_dirs.add "lib"
  end
end

Deps = App.injector
```

#### dry-auto_inject (v1.1)
- **Docs:** https://hanakai.org/learn/dry/dry-auto_inject/v1.1/
- **Repo:** https://github.com/rb/dry-auto_inject
- **Uso:** Injeção automática de dependências a partir de um container
- **Tópicos:** Basic usage, How does it work?, Injection strategies

#### dry-events (v1.1)
- **Docs:** https://hanakai.org/learn/dry/dry-events/v1.1/
- **Repo:** https://github.com/rb/dry-events
- **Uso:** Sistema publish-subscribe de eventos

#### dry-monitor (v1.0)
- **Docs:** https://hanakai.org/learn/dry/dry-monitor/v1.0/
- **Repo:** https://github.com/rb/dry-monitor
- **Uso:** Instrumentação e middleware de monitoramento
- **Tópicos:** Third Party Integrations

### 5. Integração com Frameworks

#### dry-rails (v0.7)
- **Docs:** https://hanakai.org/learn/dry/dry-rails/v0.7/
- **Repo:** https://github.com/rb/dry-rails
- **Uso:** Integração dry-rb para aplicações Rails

### 6. Gems Legadas (não recomendadas para novos projetos)

| Gem | Docs | Substituída por |
|-----|------|----------------|
| dry-container (v0.11) | https://hanakai.org/learn/dry/dry-container/v0.11/ | dry-core |
| dry-transaction (v0.16) | https://hanakai.org/learn/dry/dry-transaction/v0.16/ | dry-operation |
| dry-view (v0.8) | https://hanakai.org/learn/dry/dry-view/v0.8/ | Hanami View |
| dry-matcher (v1.0) | https://hanakai.org/learn/dry/dry-matcher/v1.0/ | dry-monads pattern matching |
| dry-equalizer | N/A | dry-core (Equalizer) |

---

## Padrões e Convenções

### Princípios do dry-rb
1. **Focado** — cada gem tem um propósito claro
2. **Componível** — gems combinam-se naturalmente
3. **Framework-agnóstico** — funciona em Ruby puro, Hanami ou Rails
4. **Explícito > mágica** — código claro, sem surpresas
5. **Funcional** — dados imutáveis, transformações explícitas
6. **Testável** — peças pequenas e focadas

### Caminhos de Aprendizado Recomendados

**Para uma app completa (Hanami, Rails, etc):**
1. dry-validation (validar inputs)
2. dry-operation (organizar processos)
3. dry-types + dry-struct (modelar domínio)

**Para uma CLI:**
- dry-cli

**Para uma gem:**
- dry-core + dry-initializer + dry-configurable + dry-logger

**Para explorar Ruby funcional:**
- dry-monads + dry-effects

---

## Nota sobre o Site

O site https://hanakai.org (antigo dry-rb.org) é uma SPA (Single Page Application). O conteúdo das páginas individuais de documentação de cada gem é carregado dinamicamente via JavaScript. Para obter o conteúdo completo de uma página específica de documentação, use o `webfetch` com a URL completa (ex: `https://hanakai.org/learn/dry/dry-validation/v1.11/`).

Os repositórios GitHub em https://github.com/dry-rb contêm o código fonte e READMEs com exemplos de uso que podem ser consultados como fallback.
