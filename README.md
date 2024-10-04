## Simulador de batalhas

##### :rotating_light: Leia o [Enunciado](https://zrp.github.io/challenges/dev/) do problema


`Docker` `Git` `Visual Studio Code`

`Ruby on Rails` `Resque` `Sneakers`

`React` `MeiliSearch` `Socket.io`

`Redis` `RabbitMQ` `PostgreSQL`
##
### pelo prompt :zap:

1. Faça o clone do repositório e dentro da raiz do projeto rode `bin/build`
2. Acesse o shell do container `zrp.api` e rode `foreman start`
##
### pelo vscode :rocket:

1. Rode o comando no Visual Code e dê ___Enter___.
    - `> Dev Containers: Clone Repository in Container Volume...`
2. Informe o _URL_ do repositório e dê ___Enter___
    - `https://github.com/leandrolasnor/zrp`
3. :hourglass_flowing_sand: Aguarde o ambiente ser construído

4. Abra o terminal integrado e rode `foreman start`
##
Acesse o [`app`](http://localhost:3001)

Acesse o serviço do [`Rabbitmq`](http://localhost:15672)

Acesse o serviço do [`Resque`](http://localhost:3000/jobs)

Acesse a [`documentação`](http://localhost:3000/api-docs)

Acesse as rotas da API [`routes`](http://localhost:3000/rails/info/routes)

Para acelerar o processo de __insurgência__, diminua o valor da variável de ambiente `INSURGENCY_TIME` em `socket.io/server/.env`

##

:bulb: _último apaga a luz_
  - `bin/down`
