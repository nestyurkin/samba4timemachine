#!/usr/bin/env bash

[[ "${USERID:-""}" =~ ^[0-9]+$ ]] && usermod -u $USERID -o smbuser
[[ "${GROUPID:-""}" =~ ^[0-9]+$ ]] && groupmod -g $GROUPID -o users

ionice -c 3 nmbd -D
ionice -c 3 smbd -FS --no-process-group </dev/null
