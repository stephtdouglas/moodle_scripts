#!/bin/bash

num=7
input_folder="CA$num"
# Make a folder for the rubrics, if needed
output_folder="CA$num/rubrics"
if [-d "$output_folder"]; then
    echo "$output_folder exists"
else
    mkdir $output_folder
fi

# Make an empty folder for marked rubrics, if needed
mark_folder="CA$num/marked"
if [-d "$mark_folder"]; then
    echo "$mark_folder exists"
else
    mkdir $mark_folder
fi

# submit_folder="CA"$num/submitted"
rubric="CA_Rubric.pdf"

# Read in the Moodle grade file to get student/submission info
grade_file=$(find $input_folder -name "Grades*.csv" )
echo $grade_file

skip_headers=1
while IFS=, read -r student_id student_name email status col5
do
    if ((skip_headers))
    then
        ((skip_headers--))
    else

        # Trim leading and trailing quotes if present
        student_id=`sed -e 's/^"//' -e 's/"$//' <<<"$student_id"`
        student_name=`sed -e 's/^"//' -e 's/"$//' <<<"$student_name"`
        status=`sed -e 's/^"//' -e 's/"$//' <<<"$status"`
        # Only keep the "Submitted for grading" part to check (or equivalent chars)
        status="${status:0:21}" 

        if [ "$status" = "Submitted for grading" ]; then
            echo "I got:$student_id and $student_name"
            read -ra id_arr <<<"$student_id"
            echo "ID alone is ${id_arr[1]}"
            outfile="$output_folder/$student_name$num$rubric"
            echo $outfile
            cp "$rubric" "$outfile" # copy the rubrics 
        else
            echo "$student_name has no submission"
            echo $status
        fi 
    fi
done < "$grade_file"
