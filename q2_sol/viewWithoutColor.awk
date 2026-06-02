#!/usr/bin/awk -f
# Usage: awk -f viewWithoutColor.awk ./resources/allCoursesTaken.csv
# Columns: Year, Semester, Code, Name, Credits, Tag, letterGrade
# Output:  Year, Semester, Code, Credits, Tag, letterGrade  (drop Name)
# Each field 20 chars wide, separator = 20*6 = 120 hyphens

BEGIN {
    FS = ","
    num_fields = 6
    sep = ""
    for (i = 1; i <= 20 * num_fields; i++) sep = sep "-"
}

NR == 1 {
    # Print header dropping field 4 (Name)
    printf "%20s%20s%20s%20s%20s%20s\n", $1, $2, $3, $5, $6, $7
    print sep
    next
}

{
    gsub(/\r/, "")
    # Strip .0 from Year
    year = $1
    sub(/\.0$/, "", year)
    # Strip .0 from Credits
    credits = $5
    sub(/\.0$/, "", credits)

    printf "%20s%20s%20s%20s%20s%20s\n", year, $2, $3, credits, $6, $7
}