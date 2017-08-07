#!/bin/sh

echo y | fly -t home set-pipeline -p fluentd-forwarder-boshrelease -c pipeline.yml -l credentials.yml