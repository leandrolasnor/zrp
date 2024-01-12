# Simulador de batalhas de heróis contra ameaças

:page_with_curl: [Enunciado do problema](https://zrp.github.io/challenges/dev/)

#### Conceitos e ferramentas utilizadas na resolução do problema
:gem: `Ruby on Rails` `React` `Redux` `RSpec` `Dry-rb`
`SOLID` `DDD` `Clear Code` `Clean Arch`
`Resque` `Sneakers` `RabbitMQ`

# Como rodar?

## Use o vscode para rodar os serviços via devcontainer

1. Com vscode aberto, digite o comando `> Dev Containers: Clone Repository in Container Volume...`.
2. Aperte `Enter`, informe a url: `https://github.com/leandrolasnor/zrp`.
3. Escolha a branch `master`.
4. :hourglass_flowing_sand:

## Ou use `makefile`

1. Faça o clone deste repositório ou copie os arquivos `makefile` e `docker-compose.yml` para um pasta na sua máquina.
2. Use o comando `make all` para baixar as imagens, subir os containers e rodar os serviços.
3. :hourglass_flowing_sand:

* Uma image docker foi publicada no [Docker Hub](https://hub.docker.com/layers/leandrolasnor/ruby/zrp/images/sha256-ce5bc45ff7c8721df11ff6fcc61a4e6a578ad314594f90a8af9904e4c4c9ee42?context=explore)

## Com os serviços rodando, faça:

* :chart_with_upwards_trend: Acesse o [`frontend`](http://localhost:3001) para ver alguns números relevantes sobre a dinâmica entre alocação e desalocação de heróis em batalhas contra ameaças. :warning: _Em desenvolvimento_
* Ao acessar a interface web, crie um usuário clicando no botão `sign up`, informe email, senha e confirme sua senha.
* É possível acelerar o processo de `insurgência`, diminuindo o valor da variável de ambiente `INSURGENCY_TIME` no `docker-compose.yml`

## Documentação

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
    - visualizar os indicadores exibidos no dashboard


## Considerações sobre o ambiente

```
# docker-compose.yml
version: '2.22'
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

  socket.io.server:
    image: leandrolasnor/ruby:zrp
    container_name: zrp.socket.io.server
    command: sh -c "yarn --cwd ./socket.io/server start"
    environment:
      - INSURGENCY_TIME=30000

  socket.io.client:
    image: leandrolasnor/ruby:zrp
    container_name: zrp.socket.io.client
    command: sh -c "yarn --cwd ./socket.io/client start"
    environment:
      - AMQP_SERVER=amqp://rabbitmq:5672
      - SOCKET_IO_SERVER=http://socket.io.server
      - SOCKET_IO_SERVER_PORT=3003
    depends_on:
      - rabbitmq
      - socket.io.server

  sneakers:
    image: leandrolasnor/ruby:zrp
    container_name: zrp.sneakers
    command: sh -c "bundle exec rake sneakers:run"
    depends_on:
      - socket.io.client
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
```
# makefile
all: prepare run

prepare:
	docker compose up api -d
	docker compose exec api bundle exec rake db:migrate:reset
	docker compose exec api bundle exec rake db:seed

run:
	docker compose up resque sneakers -d
	docker compose exec api foreman start -f Procfile.api

metric:
	docker compose exec api bundle exec rake metric:show
```
