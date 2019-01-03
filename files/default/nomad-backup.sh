#!/bin/bash

##  TZ="America/Los_Angeles"
##  CONSUL_CONFIG=/etc/consul/consul.json
##  S3_BUCKET=euclid-consul-backups
##  DC=$(cat $CONSUL_CONFIG | jq -r '.datacenter')
##  ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id | sed 's/^.*-//')
##  DT=$(date +'%Y-%m-%d+%H:%M:%S')
##  TEMPFILE="/tmp/temp-$$.snap"
##  DEST="s3://$S3_BUCKET/$DC/$ID/consul-backup.$DT.snap"

##  /usr/local/bin/consul snapshot save $TEMPFILE

##  aws s3 cp $TEMPFILE $DEST
