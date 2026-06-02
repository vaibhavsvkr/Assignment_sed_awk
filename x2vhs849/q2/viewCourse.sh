#!/bin/bash
# Usage: ./calculateCPI.sh ./resources/allCoursesTaken.csv ./resources/letterGradeToNumber.csv
# CPI = sum(credits * gradepoint) / sum(credits)

COURSES="$1"
GRADE_MAP="$2"

awk '
BEGIN { FS = "," }

function trim(s) {
    gsub(/^[ \t\r]+|[ \t\r]+$/, "", s)
    return s
}

# First file: letterGradeToNumber.csv  (letterGrade, Number)
NR == FNR {
    if (FNR == 1) { next }
    grade = trim($1)
    gp    = trim($2) + 0
    grade_point[grade] = gp
    next
}

# Second file: allCoursesTaken.csv
# Year,Semester,Code,Name,Credits,Tag,letterGrade
{
    if (FNR == 1) { next }
    credits = trim($5) + 0
    grade   = trim($7)
    if (grade in grade_point) {
        total_weighted += credits * grade_point[grade]
        total_credits  += credits
    }
}

END {
    if (total_credits > 0)
        printf "%.4f\n", total_weighted / total_credits
    else
        print "0.0000"
}
' "$GRADE_MAP" "$COURSES"
