rails: rails s -p 3000 -b 0.0.0.0 -P tmp/pids/rails.pid
resque: COUNT=$(($(nproc) - 1)) QUEUE=critical,default,low_priority rake resque:workers
scheduler: rake resque:scheduler
cable: puma -p 28080 cable/config.ru
gruf: gruf
sneakers: sneakers work Processor --require ./sneakers/processor.rb
react: corepack yarn workspace react start
