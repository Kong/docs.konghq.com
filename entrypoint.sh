#!/bin/bash

bundle install
yarn --ignore-engines
gulp clean
gulp
