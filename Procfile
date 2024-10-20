rails: bundle exec rails s -p 3000 -b 0.0.0.0 -P tmp/pids/rails.pid
resque: bundle exec rake resque:workers COUNT=4 QUEUE=*
scheduler: bundle exec rake resque:scheduler
cable: bundle exec puma -p 28080 cable/config.ru
gruf: bundle exec gruf
sneakers: sneakers work Processor --require ./sneakers/alerts.rb
react: yarn --cwd ./reacting start
socket-io-server: yarn --cwd ./socket.io/server start
socket-io-client: yarn --cwd ./socket.io/client start
