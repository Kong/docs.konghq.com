#!/bin/bash

bundle install
yarn --ignore-engines
make clean
make build
