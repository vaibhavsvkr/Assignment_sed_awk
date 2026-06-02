#!/usr/bin/awk -f
# Usage: awk -f viewWithoutColor.awk ./resources/allCoursesTaken.csv

BEGIN {
    FS = ","
    num_fields = 6
    sep = ""
    for (i = 1; i <= 20 * num_fields; i++) sep = sep "-"
}

NR == 1 {
    # Strip \r from header fields
    for (i = 1; i <= NF; i++) gsub(/\r/, "", $i)
    # separator, header, separator
    print sep
    printf "%20s%20s%20s%20s%20s%20s\n", $1, $2, $3, $5, $6, $7
    print sep
    next
}

{
    gsub(/\r/, "")
    year = $1;    sub(/\.0$/, "", year)
    credits = $5; sub(/\.0$/, "", credits)
    printf "%20s%20s%20s%20s%20s%20s\n", year, $2, $3, credits, $6, $7
}
