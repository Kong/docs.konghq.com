#!/bin/bash

npm install -g yarn
npm install -g gulp
bundle install
yarn --ignore-engines
gulp clean
gulp
