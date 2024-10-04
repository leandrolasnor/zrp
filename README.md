# Simulador de batalhas

##### :link: [Enunciado](https://zrp.github.io/challenges/dev/)


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
Acesse o [`frontend`](http://localhost:3001) e a [`documentação`](http://localhost:3000/api-docs) :link:

Para acelerar o processo de __insurgência__, diminua o valor da variável de ambiente `INSURGENCY_TIME` em `socket.io/server/.env`
