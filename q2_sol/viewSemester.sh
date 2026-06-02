#!/bin/bash
# Usage: ./viewSemester.sh outputB <Semester> <Year>
# Filters lines from outputB matching the given semester and year,
# sorts by course code (field 3, cols 41-60), preserves ANSI colors.

OUTPUT_B="$1"
SEMESTER="$2"
YEAR="$3"

# Print header (first 2 lines: header row + separator)
head -2 "$OUTPUT_B"

# Filter and sort remaining lines.
# In the 20-wide formatted output:
#   Col  1-20  : Year
#   Col 21-40  : Semester
#   Col 41-60  : Code
#   Col 61-80  : Credits
#   Col 81-100 : Tag
#   Col 101-120: letterGrade
#
# ANSI escape codes are embedded; we strip them only for comparison,
# but print the original colored line.

tail -n +3 "$OUTPUT_B" | awk -v sem="$SEMESTER" -v yr="$YEAR" '
{
    line = $0
    # Strip ANSI codes for field extraction only
    plain = line
    gsub(/\033\[[0-9;]*m/, "", plain)

    year_field = substr(plain, 1,  20); gsub(/^[ \t]+|[ \t]+$/, "", year_field)
    sem_field  = substr(plain, 21, 20); gsub(/^[ \t]+|[ \t]+$/, "", sem_field)
    code_field = substr(plain, 41, 20); gsub(/^[ \t]+|[ \t]+$/, "", code_field)

    if (year_field == yr && sem_field == sem) {
        print code_field "\t" line
    }
}
' | sort -k1,1 | cut -f2-
