rails: bundle exec rails s -p 3000 -b 0.0.0.0 -P tmp/pids/rails.pid
cable: bundle exec puma -p 28080 cable/config.ru
react: yarn --cwd ./reacting start
resque: bundle exec rake resque:workers COUNT=4 QUEUE=*
scheduler: bundle exec rake resque:scheduler
# sneakers: bundle exec rake sneakers:run
grpc: bundle exec ruby ./grpc/server.rb
socket-io-server: yarn --cwd ./socket.io/server start
socket-io-client: yarn --cwd ./socket.io/client start
