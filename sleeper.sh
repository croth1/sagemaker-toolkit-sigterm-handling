#!/usr/bin/env bash

_end_gracefully() {
    echo "bye bye!"
    kill -TERM $pid
    exit 0
}

trap _end_gracefully SIGTERM

sleep 50000000 & 
pid=$!
wait