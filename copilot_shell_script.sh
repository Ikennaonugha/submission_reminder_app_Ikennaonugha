#!/bin/bash

# Prompt the user to enter the new assignment name
read -p "Enter the new name of the assignment: " assignment_name

# Find the submission_reminder_app directory.
directory=$(find . -maxdepth 1 -type d -name "submission_reminder_*" | head -n 1 )

# Check if the directory was found.
if [[ -z "$directory" ]]; then # Corrected: "$directory" instead of "directory"
    echo "Error: 'submission_reminder_*' directory not found."
    echo "Please ensure you run this script from the same directory where 'create_environment.sh' was executed."
    exit 1
fi

# Define the path to the config file
config_file="$directory/config/config.env"

# Check if the config file exists
if [[ ! -f "$config_file" ]]; then
    echo "Error: Configuration file '$config_file' not found."
    echo "Please ensure the application environment was correctly created."
    exit 1
fi

# Use sed to replace the ASSIGNMENT value in the config.env file.
echo "Updating ASSIGNMENT in $config_file to '$assignment_name'..."
sed -i "s/^ASSIGNMENT=\".*\"/ASSIGNMENT=\"$assignment_name\"/" "$config_file"

# Run the startup.sh script
echo "Running the application with the updated assignment..."
"./$directory/startup.sh"

echo "Operation complete. The application has been re-run with the new assignment name."
