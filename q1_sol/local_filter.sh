#!/bin/bash
# Usage: ./local_filter.sh <input> <output>
# app.log format:
#   2026-07-10 08:11:21 ERROR cache module=adapter worker=2 code=E203 message=...
#   $1=date  $2=time  $3=level  $4=component  $5=module=X  $6=worker=X  $7=code=XXX

INPUT="$1"
OUTPUT="$2"

mkdir -p "$OUTPUT"

awk '
/ERROR/ {
    # Extract code value from the field that starts with "code="
    code = ""
    for (i = 1; i <= NF; i++) {
        if ($i ~ /^code=/) {
            split($i, a, "=")
            code = a[2]
            break
        }
    }
    print $1, $2, code
}
' "$INPUT" > "$OUTPUT/error_lines.txt"
