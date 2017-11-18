#!/bin/sh
set -e

CPULIMIT_INFO='Running without limiting CPU.
Install cpulimit for best experience: https://github.com/opsengine/cpulimit

On Mac, you can use Homebrew:
brew install cpulimit
'

if [ "$1" = '-R' ]; then
  echo
  echo 'Not resetting blockchain'
  echo
  if ! [ -d '.blockchain' ]; then
    tar -xzf blockchain.tar.gz
  fi
else
  echo
  echo 'Resetting blockchain...'
  echo
  rm -rf .blockchain
  tar -xzf blockchain.tar.gz
fi

run() {
  if command -v cpulimit >/dev/null; then
    set -x
    exec cpulimit -i -l 50 "$@"
  else
    echo "$CPULIMIT_INFO"
    set -x
    exec nice -n 10 "$@"
  fi
}

run geth \
  --datadir='.blockchain' \
  --networkid=12342 \
  --nodiscover \
  --maxpeers 0 \
  --port=30342 \
  --rpc --rpcapi='db,eth,net,web3,personal' \
  --rpcport '9545' --rpcaddr '127.0.0.1' --rpccorsdomain '*' \
  --unlock '0,1' \
  --password geth-passwords.txt \
  --mine \
  --minerthreads=1 \
  console
