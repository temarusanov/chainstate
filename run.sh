#!/bin/sh

SCRIPT=$(cd $(dirname $0); /bin/pwd)
COIN=${1:-bitcoin}
COINDAEMON=${2:-$COIN}
COINDIR=${3:-$COIN}
RANDOMSTR=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
BALANCES_FILE=balances-${COIN}-$(TZ=UTC date +%Y%m%d-%H%M)-${RANDOMSTR}
BALANCES_FILE_SAMPLE=balances-${COIN}-$(TZ=UTC date +%Y%m%d-%H%M)-sample

echo "Cleaning existing files..."
rm -rf ./state ./cs.out ./cs.err

echo "${COINDAEMON} status"
systemctl status ${COINDAEMON} --no-pager

echo "Stopping ${COINDAEMON}..."
systemctl stop ${COINDAEMON}

echo "Copying chainstate from ${COINDIR}"
cp -Rp ${COINDIR} state

echo "Syncing..."
sync

echo "Copying done. Restarting ${COINDAEMON}..."
systemctl start ${COINDAEMON}

echo "Running chainstate parser..."
./chainstate ${COIN} >cs.out 2>cs.err

echo "Generated output:"
ls -l cs.out cs.err

if test ! -e cs.out; then
    echo "Missing input file (cs.out)"
    exit 1
fi

exit 0
