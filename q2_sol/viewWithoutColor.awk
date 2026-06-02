#!/usr/bin/awk -f
# Usage: awk -f viewWithoutColor.awk ./resources/allCoursesTaken.csv
#
# Displays allCoursesTaken.csv in a formatted table.
# Removes the "Name" column (assumed col 4).
# Each field is 20 characters wide.
# Header separator = 20 * number_of_fields hyphens.
#
# CSV columns: Year, Semester, Code, Name, Credits, Tag, letterGrade
#              $1     $2        $3    $4    $5        $6   $7
# Output cols: Year, Semester, Code, Credits, Tag, letterGrade  (drop Name)

BEGIN {
    FS = ","
    OFS = ""
    # Number of output fields (7 - 1 = 6)
    num_fields = 6
    sep_len = 20 * num_fields
    # Build separator line
    sep = ""
    for (i = 1; i <= sep_len; i++) sep = sep "-"
}

NR == 1 {
    # Print header row (drop field 4 = Name)
    printf("%20s%20s%20s%20s%20s%20s\n", $1, $2, $3, $5, $6, $7)
    print sep
    next
}

{
    # Strip possible \r (Windows line endings)
    gsub(/\r/, "")
    # Strip leading/trailing spaces from each field
    for (i = 1; i <= NF; i++) {
        gsub(/^[ \t]+|[ \t]+$/, "", $i)
    }
    # Print data row (drop field 4 = Name)
    printf("%20s%20s%20s%20s%20s%20s\n", $1, $2, $3, $5, $6, $7)
}
