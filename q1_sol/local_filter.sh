#!/bin/bash
# Usage: ./local_filter.sh <input> <output>
# Filters ERROR lines from app.log and prints date, time, error_code.
#
# Assumed app.log format (common log4j / syslog-style):
#   2024-07-10 08:11:09 ERROR [module] ERR_CODE: some message
# Fields: $1=date  $2=time  $3=level  $4=[module]  $5=error_code ...
#
# Adjust field indices below if your actual log format differs.

INPUT="$1"
OUTPUT="$2"

mkdir -p "$OUTPUT"

awk '
/ERROR/ {
    # $1 = date, $2 = time, $3 = level (ERROR), $4 = [component], $5 = error_code
    # Print date, time, and error code (field 5, strip trailing colon if present)
    error_code = $5
    sub(/:$/, "", error_code)
    print $1, $2, error_code
}
' "$INPUT" > "$OUTPUT/error_lines.txt"
