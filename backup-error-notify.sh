#!/bin/bash

# Simple wrapper script to send notifications on errors

./backup.sh || ./notify.sh 'Backup failed'
