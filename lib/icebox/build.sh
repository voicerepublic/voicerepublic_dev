#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"

cd $DIR

docker build -t branch14/icecast2 .
