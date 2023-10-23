# Desafio para Fullstack - ZRP

Este documento descreve o passo a passo para rodar a aplicação referente ao desafio da vaga de Fullstack da ZRP

[Enunciado do problema](https://zrp.github.io/challenges/dev/)

:warning: _Somente back-end_

## Considerações sobre o ambiente

* Uma image docker foi publicada no [Docker Hub](https://hub.docker.com/layers/leandrolasnor/ruby/zrp/images/sha256-ce5bc45ff7c8721df11ff6fcc61a4e6a578ad314594f90a8af9904e4c4c9ee42?context=explore)

* Use o comando `docker compose up db api -d` para baixar a imagem e subir os containers _api_, _db_ e _redis_
* Use o comando `docker compose exec api bundle exec rake db:migrate:reset` para criar o banco de dados
* Use o comando `docker compose exec api bundle exec rake db:seed` para popular o banco de dados com alguns heróis

```
# docker-compose.yml
version: '3.8'
services:
  rabbitmq:
    image: rabbitmq:management
    container_name: zrp.rabbitmq
    environment:
      - RABBITMQ_DEFAULT_USER=guest
      - RABBITMQ_DEFAULT_PASS=guest
    ports:
      - "5672:5672"
      - "15672:15672"

  socket.io:
    image: leandrolasnor/ruby:zrp
    container_name: zrp.socket.io
    command: sh -c "yarn start"
    depends_on:
      - rabbitmq

  sneakers:
    image: leandrolasnor/ruby:zrp
    container_name: zrp.sneakers
    command: sh -c "bundle exec rake sneakers:run"
    depends_on:
      - socket.io
      - db

  redis:
    image: redis:alpine
    container_name: zrp.redis
    environment:
        ALLOW_EMPTY_PASSWORD: 'yes'
    ports:
        - "6379:6379"

  resque:
    image: leandrolasnor/ruby:zrp
    container_name: zrp.resque
    command: sh -c "foreman start"
    depends_on:
      - redis
      - db

  api:
    image: leandrolasnor/ruby:zrp
    container_name: zrp.api
    stdin_open: true
    tty: true
    command: sh
    ports:
      - "3000:3000"
    depends_on:
      - redis
      - db

  db:
    image: bitnami/postgresql:latest
    container_name: zrp.postgresql
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: user
      POSTGRES_DB: zrp
    ports:
      - "5432:5432"

```

## Considerações sobre a aplicação

#### Conceitos e ferramentas utilizadas na resolução do problema
* Princípio de Inversão de Dependência
* Princípio da Segregação da Interface
* Princípio da responsabilidade única
* Princípio da substituição de Liskov
* Princípio Aberto-Fechado
* Background Processing
* Domain Driven Design
* Código Limpo
* Rubocop
* Bullet
* Dry-rb
* RSpec

## Passo a Passo de como executar a solução

_presumo que nesse momento seu ambiente esteja devidamente configurado e o banco de dados criado e populado_

* Use o comando `docker compose up resque sneakers -d` para rodar o restante dos serviços
* Use o comando `docker compose exec api bundle exec rake metric:show` para ver alguns números relevantes sobre a dinâmica entre alocação e desalocação de heróis em batalhas contra ameaças.
* Use o comando `docker compose exec api rails s -b 0.0.0.0` para rodar o servidor
* Acesse o [`Swagger`](http://localhost:3000/api-docs)
* Verifique o campo `defaultHost` na interface do [`Swagger`](http://localhost:3000/api-docs) e avalie se a url esta correta (_127.0.0.1:3000_ ou _localhost:3000_)

* Nessa interface você poderá validar a documentação dos endpoints e testá-los, enviando algumas requisições http
* É necessário estar logado para interagir com a api - utilize o endpoint **POST** `/auth` (_create user_) para criar um usuário. Informe email, password e confirme o password
* No `response` copie o `header` **authorization** - seu valor será como este: *Bearer eyJhY2Nlc3MtdG9rZW4iOiJyNzV4Wi1KM1psbnQ0R2FVSGFzTUxnIiwidG9rZW4tdHlwZSI6IkJlYXJlciIsImNsaWVudCI6IlhxMEpHSWs5ZkV5RzhURXZhNWxpUXciLCJleHBpcnkiOiIxNjk3NDQyODUwIiwidWlkIjoic3RyaW5nQHRlc3QuY29tIn0=*
* Copie o `token` e clique no botão **Authorize** no canto superior direito da interface do [`Swagger`](http://localhost:3000/api-docs)
* Cole e conteúdo, clique em **Authorize** e depois em **Close**
* Agora será possível integarir com a api pela interface do [`Swagger`](http://localhost:3000/api-docs)

    - cria herói
    - lista os heróis
    - atualiza os dados de um herói
    - remove um herói
    - mostra o histórico decrescente de ameaças ordenada pela sua ocorrencia
