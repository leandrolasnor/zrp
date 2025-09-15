### IHEROS _ BATTLE SIMULATOR
![plot](./print_screen.png)
###### RUNNING THE APPLICATION USING TERMINAL :zap:
```
git clone https://github.com/leandrolasnor/zrp.git && \
make exec _C zrp
```
```
 _________________________________________________
| Name            | CPU %  | Memory Usage / Limit |
|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
| zrp.api         | 9.78%  |      4.557GiB / 6GiB |
| zrp.pgadmin     | 0.06%  |    211.3MiB / 512MiB |
| zrp.redis       | 1.30%  |     5.398MiB / 28MiB |
| zrp.postgresql  | 0.02%  |    52.54MiB / 128MiB |
| zrp.rabbitmq    | 0.89%  |    75.55MiB / 128MiB |
| zrp.meilisearch | 0.43%  |    21.69MiB / 256MiB |
|_________________________________________________|
|   suitable for a machine with ≥ 12 GiB of RAM   |
 ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
 ```
###### SERVICE WEB INTERFACE
[`Rails`](http://localhost:3000/rails/info/routes) [`Resque`](http://localhost:3000/jobs) [`React`](http://localhost:5600) [`MeiliSearch`](http://localhost:7700) [`Rabbitmq`](http://localhost:15672) [`Swagger`](http://localhost:3000/api_docs) [`PostgreSQL`](http://localhost:8080)

`Docker` `Git` `Visual Studio Code`
`Socket.io` `Sneakers` `Redis` `gRPC`

`dry_rb` `Rails Event Store`
#### You are in the year 3150 and are leading the technology division responsible for developing the hero distribution management system to combat threats. The system must monitor threat alerts provided by the UN and allocate heroes to each new threat around the globe, always clearly assigning the hero closest to the location.

#### You must listen to notifications from a broadcast system developed by the UN that reports threats randomly across the globe, and the head of the Hero Operations Department has established the following rules to ensure that threats are properly handled:

#### Each Hero and each Threat has a rank. Heroes must be allocated based on their location (always the closest) and a rank appropriate to the threat level. After a certain amount of time, heroes must be deallocated.

#### The ranks are as follows:
_ ###### Heroes: Classes S, A, B, and C
_ ###### Threats: Levels God, Dragon, Tiger, and Wolf

#### __Class S heroes__ have priority against __God_level threats__
_ ###### A battle with a threat of this level must last at least 5 minutes and at most 10 minutes;

##### __Class A heroes__ have priority against __Dragon_level threats__
_ ###### A battle with a threat of this level must last at least 2 minutes and at most 5 minutes;

##### __Class B heroes__ have priority against __Tiger_level threats__
_ ###### A battle with a threat of this level must last at least 10 seconds and at most 20 seconds;

##### __Class C heroes__ have priority against __Wolf_level threats__
_ ###### A battle with a threat of this level must last at least 1 second and at most 2 seconds;

###### You can allocate twice the number of lower_ranked heroes to deal with a higher_ranked threat if they are closer. In other words, double the heroic force is enough to handle a higher_level threat.

###### You must consume a socket (built using socket.io) that returns information about detected threats, and each threat has the following format:

```
{
    "location": {
        "lat": _5.836597,
        "lng": _35.236007,
    },
    "dangerLevel": "Dragon",
    "monsterName": "Black Dragon"
}
```
