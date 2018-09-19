#!/bin/bash

rm -rf node_modules
npm install -f
npm install -g gulp
gem install bundler
bundle install
gulp clean
gulp