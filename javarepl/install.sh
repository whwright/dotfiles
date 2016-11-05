#!/bin/bash

# is this a bad idea?
DOWNLOAD_LINK="http://albertlatacz.published.s3.amazonaws.com/javarepl/javarepl.jar"

sudo curl --silent --show-error -o "/opt/javarepl.jar" "${DOWNLOAD_LINK}"
