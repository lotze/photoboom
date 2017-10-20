web: bundle exec rails server thin -p $PORT -e $RACK_ENV
resque: env QUEUE=* TERM_CHILD=1 RESQUE_PRE_SHUTDOWN_TIMEOUT=5 COUNT=3 RESQUE_TERM_TIMEOUT=10 bundle exec rake resque:work
scheduler: bundle exec rake resque:scheduler
