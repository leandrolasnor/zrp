rails: rails s -p 3000 -b 0.0.0.0 -P tmp/pids/rails.pid
resque: COUNT=$(nproc) QUEUE=critical,default,low_priority rake resque:workers
scheduler: rake resque:scheduler
cable: puma -p 28080 cable/config.ru
gruf: gruf
sneakers: sneakers work Processor --require ./sneakers/processor.rb
react: yarn workspace react start
socket-io-server: yarn workspace socket.io.server start
socket-io-client: yarn workspace socket.io.client start
