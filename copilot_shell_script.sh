#!/bin/bash
read -p "Enter the name of the assignment: " assignment_name

directory=$(find . -maxdepth 1 -type d -name "submission_reminder_*" | head -n 1 )

#checks if directory was found.
if [[ -z "directory" ]]; then
	echo "Error: 'submission_reminder_app' directory not found."
	echo "Run this script from the same directory 'create_environment.sh' was executed"
	exit 1
fi

config_file="$directory/congfig/config.env"
sed -i "s/^ASSIGNMENT=\".*\"/ASSIGNMENT=\"$assignment_name\"/" "$config_file"

#running startup.sh
./${directory}/startup.sh
