#!/bin/bash

PRESICION="${PRESICION:-2}"
SAMPLES="${SAMPLES:-800}"
CHANNELS="${CHANNELS:-left right}"

ls -lAh /share

/wav2json-master/bin/Linux/wav2json -s $SAMPLES \
				    --channels $CHANNELS \
				    -p $PRESICION \
				    -n /share/$INPUT

ls -lAh /share
