#!/bin/sh

echo `date` syncing >> /share/actions.log

aws s3 sync /share $STORAGE >> sync.log
