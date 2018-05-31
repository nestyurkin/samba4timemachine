#!/usr/bin/env bash

user() { local name="$1" passwd="$2" id="${3:-""}" group="${4:-""}"
    [[ "$group" ]] && { grep -q "^$group:" /etc/group || addgroup "$group"; }
    grep -q "^$name:" /etc/passwd ||
        adduser -D -H ${group:+-G $group} ${id:+-u $id} "$name"
    echo -e "$passwd\n$passwd" | smbpasswd -s -a "$name"
}


[[ "${USERID:-""}" =~ ^[0-9]+$ ]] && usermod -u $USERID -o smbuser
[[ "${GROUPID:-""}" =~ ^[0-9]+$ ]] && groupmod -g $GROUPID -o users

[[ "${USER:-""}" ]] && eval user $(sed 's/^/"/; s/$/"/; s/;/" "/g' <<< $USER)

ionice -c 3 nmbd -D
ionice -c 3 smbd -FS --no-process-group </dev/null
