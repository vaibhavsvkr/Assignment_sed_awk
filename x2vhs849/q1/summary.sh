#!/bin/bash
# Usage: ./summary.sh <input> <output>
# Produces top 10 usernames by failed login count, descending count,
# ties broken by ascending lexicographic order of username.

INPUT="$1"
OUTPUT="$2"

mkdir -p "$OUTPUT"

awk '
/Failed password for/ {
    if ($9 == "invalid" && $10 == "user") {
        username = $11
    } else {
        username = $9
    }
    count[username]++
}
END {
    for (u in count) {
        print count[u], u
    }
}
' "$INPUT" \
| sort -k1,1nr -k2,2 \
| head -10 \
| awk '{print $2, $1}' \
> "$OUTPUT/top_failed_users.txt"
