#!/bin/bash

case $1 in
    config)
        echo 'graph_title Raindrops'
        echo 'graph_vlabel Dispatchers/Clients'
        curl -k https://localhost/_raindrops | \
          sed 'y/\/ /_-/' | sed 's/\(.*\):-.*/\1.label \1/'
    ;;
    *)
        curl -k https://localhost/_raindrops | \
          sed 'y/\/ /_-/' | sed 's/:-/.value /'
esac
