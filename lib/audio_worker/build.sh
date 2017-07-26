#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"

cd $DIR

if [ -d fidleity ]; then
    (cd fidleity && git pull)
else
    git clone git@github.com:munen/fidelity.git
fi

docker build -t branch14/audio_worker .
