#!/bin/bash

set -euo pipefail

cd $1

tar xvf data.tar.gz

rm -f data.tar.gz metadata.gz checksums.yaml.gz
