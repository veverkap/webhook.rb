#!/bin/bash
gem install sinatra
gem install sinatra-contrib
if [ "$RACK_ENV" == "production" ];
then
  bundle install --without development test
  ruby $MAIN_APP_FILE -p 80
else
  bundle install
  if [ "$RACK_ENV" == "test" ];
  then
    rspec
  else
    ruby $MAIN_APP_FILE -p 80 -o '0.0.0.0'
  fi
fi

