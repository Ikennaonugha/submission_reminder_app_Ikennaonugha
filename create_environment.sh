#!/bin/bash

#Prompts user for name
read -p "Enter your name: " name

#name validation check
if [[ -z "$name" ]] ; then
	echo "Error: Name can't be empty."
	exit 1
fi

#creates directory from given name
new_directory="submission_reminder_${name}"
echo "Creating directory '$new_directory'"

#checking if directory already exists
if [[ -d "$new_directory" ]] ; then
	echo "Warning: Directory '$new_directory' already exists"
	echo "All contents will be overwriten if continued"
	read -p "Do you wish to continue? (Yes/No): " overwrite
	if [[ "$overwrite" == "YES" ]]; then
		rm -rf "$PWD/${new_directory}"
	fi
	echo "Exiting...."
	exit 0
fi

mkdir -p "${new_directory}"

#creating subdirectories
echo "Creating subdirectories: app, modules, assets, config"
cd "${new_directory}"
mkdir app modules assets config

#populating the files using EOF

config_path="config/config.env"
cat << EOF >>  "$config_path"
# Configuration for the Submission Reminder App
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

submission_path="assests/submissions.txt"
cat << EOF >> "$submission_path"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Ikenna, Shell Navigation, submitted
Billie, Git, not submitted
Drake, Shell Basics, submitted
Yeat, Shell Navigation, not submitted
Amala, Git, not submitted
EOF

function_path="modules/functions.sh"
cat << EOF >> "$function_path"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

reminder_path="app/reminder.sh"
cat << EOF >> "$reminder_path"
#!/bin/bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

#creating startup.sh script and its content

















