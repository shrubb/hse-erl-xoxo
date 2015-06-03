#!/bin/bash
cd compiled
erlc ../src/game_server.erl
cd ..
erl -noshell -pa ./compiled -s game_server -s inets -config server
