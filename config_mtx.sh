#!/usr/bin/env bash
if [ -z "$MEDIAMTX_FILE" ]; then
    printf "[WARN]: Please set a value for %s !\n" "MEDIAMTX_FILE"
else
    if [ -z "$MTX_PATH" ]; then
      export MTX_PATH=cam      
    fi
    if [ -z "$1" ]; then      
      printf "[$0]: Used %s as the default stream.\n" "$MTX_PATH"
    else
      export MTX_PATH="$1"
    fi
    cp -fv rtsp-simple-server-"$MTX_PATH".template "$MEDIAMTX_FILE"
fi

