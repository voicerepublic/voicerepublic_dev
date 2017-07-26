#!/bin/bash

PRESICION="${PRESICION:-2}"
SAMPLES="${SAMPLES:-800}"
CHANNELS="${CHANNELS:-left right}"

/wav2json-master/bin/Linux/wav2json -s $SAMPLES \
				    --channels $CHANNELS \
				    -p $PRESICION \
				    -n $1
