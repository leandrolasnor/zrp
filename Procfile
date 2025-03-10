rails: bin/rails s -p 3000 -b 0.0.0.0 -P tmp/pids/rails.pid
resque: COUNT=4 QUEUE=* bin/rake resque:workers
scheduler: bin/rake resque:scheduler
cable: bin/puma -p 28080 cable/config.ru
gruf: bin/gruf
sneakers: bin/sneakers work Processor --require ./sneakers/alerts.rb
react: yarn --cwd ./react start
socket-io-server: yarn --cwd ./socket.io/server start
socket-io-client: yarn --cwd ./socket.io/client start
