rails: rails s -p 3000 -b 0.0.0.0 -P tmp/pids/rails.pid
resque_allocation: COUNT=2 QUEUE=allocated,matches rake resque:workers
resque_notify: COUNT=6 QUEUE=*,!allocated,!matches rake resque:workers
scheduler: rake resque:scheduler
cable: puma -p 28080 cable/config.ru
gruf: gruf
sneakers: sneakers work Processor --require ./sneakers/alerts.rb
react: yarn --cwd ./react start
socket-io-server: yarn --cwd ./socket.io/server start
socket-io-client: yarn --cwd ./socket.io/client start
