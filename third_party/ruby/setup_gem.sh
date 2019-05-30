#!/bin/bash

set -euo pipefail

cd $1
pwd

echo "Unpacking data"
tar xvf data.tar.gz

echo "removing other stuff"
rm -f data.tar.gz metadata.gz checksums.yaml.gz
