#!/bin/bash

npm install -g yarn
npm install -g gulp
bundle install
yarn
gulp clean
gulp
