#!/bin/bash
bundle check || bundle install --jobs 20 --retry 5

if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

rdebug-ide --host 0.0.0.0 --port 1234 -- bin/rails s -b 0.0.0.0
#bin/rails s -p $PORT -b 0.0.0.0 -e $RAILS_ENV