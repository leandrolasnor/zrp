rails: bundle exec rails s -p 3000 -b 0.0.0.0
cable: bundle exec puma -p 28080 -P tmp/pids/cable.pid cable/config.ru
react: yarn --cwd ./reacting start
resque: bundle exec rake resque:workers COUNT=4 QUEUE=*
scheduler: bundle exec rake resque:scheduler
sneakers: bundle exec rake sneakers:run
socket-io-server: yarn --cwd ./socket.io/server start
socket-io-client: yarn --cwd ./socket.io/client start
