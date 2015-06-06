#!/bin/bash
mkdir compiled > /dev/null 2>&1 # don't print warnings
cd compiled
erlc ../src/game_server.erl
cd ..
erl -noshell -pa ./compiled -s game_server -s inets -config server
