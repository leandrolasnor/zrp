rails: bundle exec rails s -p 3000 -b 0.0.0.0 -P tmp/pids/rails.pid
resque: COUNT=4 QUEUE=* bundle exec rake resque:workers
scheduler: bundle exec rake resque:scheduler
cable: bundle exec puma -p 28080 cable/config.ru
gruf: bundle exec gruf
sneakers: bundle exec sneakers work Processor --require ./sneakers/alerts.rb
react: yarn --cwd ./react start
socket-io-server: yarn --cwd ./socket.io/server start
socket-io-client: yarn --cwd ./socket.io/client start
