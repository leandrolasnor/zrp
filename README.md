# Simulador de batalhas de heróis contra ameaças

:page_with_curl: [Enunciado do problema](https://zrp.github.io/challenges/dev/)

#### Conceitos e ferramentas utilizadas na resolução do problema
`Docker`

`Ruby on Rails` `Dry-rb`

`React` `Redux` `MeiliSearch` `Socket.io`

`SOLID` `DDD` `Clear Code` `Clean Arch`

`Resque` `Sneakers` `Redis` `RabbitMQ`

`RSpec` `RSwag`

`PostgreSQL`

# Como rodar?

## .devcontainer :whale:

1. Rode o comando no Visual Code `> Dev Containers: Clone Repository in Container Volume...` e dê `Enter`.
2. Informe a url: `https://github.com/leandrolasnor/zrp` e dê `Enter`
4. :hourglass_flowing_sand: Aguarde até [+] Building **352.7s** (31/31) FINISHED

## Com o processo de build concluido, faça:

* Rode o comando no terminal: `foreman start`
* :chart_with_upwards_trend: Acesse o [`frontend`](http://localhost:3001) para ver alguns números relevantes sobre a dinâmica entre alocação e desalocação de heróis em batalhas contra ameaças. :warning: _Em desenvolvimento_
* Ao acessar a interface web, crie um usuário clicando no botão `sign up`, informe email, senha e confirme sua senha.
* É possível acelerar o processo de `insurgência`, diminuindo o valor da variável de ambiente `INSURGENCY_TIME` em `.devcontainer/devcontainer.json:34`

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
