#!/bin/bash

set -e

mv "$1" "$(dirname "$0")/destination/$2"
