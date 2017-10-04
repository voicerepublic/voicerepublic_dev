#!/bin/bash

while true
do
    /usr/bin/liquidsoap -v ./icebox.liq &
    wait $!
    sleep 1
done
