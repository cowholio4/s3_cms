#!/bin/bash
set -e

# install yarn packages
# yarn install

# in prod we should not do this but in dev if we add a gem to the
# Gemfile we will get an error if we don't install immediately
bundle install

# Precompile assets for production
# bundle exec rails assets:precompile

# Delete old server
if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
fi

exec bundle exec "$@"
