#!/bin/bash

# is this a bad idea?
DOWNLOAD_LINK="http://albertlatacz.published.s3.amazonaws.com/javarepl/javarepl.jar"

curl --fail --silent --show-error ${DOWNLOAD_LINK} --output /opt/javarepl.jar
