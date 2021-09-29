#!/bin/bash

# Simple wrapper script to send notifications on errors

cd "$(dirname "$0")"

./backup.sh || ./notify.sh 'Backup failed'
