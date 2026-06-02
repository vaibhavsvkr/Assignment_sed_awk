#!/bin/bash
# Usage: ./failed_login.sh <input> <output>
# Extracts failed login attempts from auth.log

INPUT="$1"
OUTPUT="$2"

mkdir -p "$OUTPUT"

awk '
/Failed password for/ {
    month = $1
    day   = $2
    time  = $3

    # Detect "invalid user" form vs regular user form
    # Form 1: Failed password for root from <ip> ...
    # Form 2: Failed password for invalid user guest from <ip> ...

    if ($9 == "invalid" && $10 == "user") {
        username = $11
        ip       = $13
    } else {
        username = $9
        ip       = $11
    }

    print month, day, time, username, ip
}
' "$INPUT" > "$OUTPUT/failed_logins.txt"
