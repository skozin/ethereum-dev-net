#!/bin/sh

rm -rf .blockchain
mkdir -p .blockchain

set -x

geth \
  --datadir .blockchain \
  --networkid=12342 \
  init genesis.json
