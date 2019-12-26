#!/bin/bash
set -e
mongo --host mongo markazuna --eval 'db.createUser({user:"admin",pwd:"mutia.1975@2019",roles:["readWrite"],mechanisms:["SCRAM-SHA-1"]});'
RAILS_ENV='production' bundle exec rails db:seed