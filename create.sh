#!/bin/bash

#prompts the user for their name
read -p "Enter a name: " name

new_dir="submission_reminder_${name}"

#check if a name was entered
if [[ -z "${name}" ]]; then
	echo "Field can not be empty. Exiting..."
	exit 1 #exit the script
fi

#check if the name already exists and is a directory
if [[ -d "$new_dir" ]]; then
	echo "This directory already exists"
	read -p "Do you wish to overwrite? (Y/N):" overwrite
	
	case "$overwrite" in
	        [yY])
	            echo "Overwriting directory..."
	            rm -rf "$new_dir"
           
	            ;;
        	[nN])
	            echo "Exiting..."
	            exit 1 #exit the script
	            ;;
        	*)
	            echo "Invalid choice. Please answer Y or N."
        	    echo "Exiting..."
		    exit 1
	            ;;
    	esac
fi
mkdir -p $new_dir

mkdir -p $new_dir/app
mkdir -p $new_dir/modules
mkdir -p $new_dir/assets
mkdir -p $new_dir/config


#creating the files and populating it

cat > "$new_dir/app/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

cat > "${new_dir}/modules/functions.sh" << 'EOF'
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

cat > "$new_dir/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Amirah, Git , not submitted 
Kim, Shell Basics, submitted 
De Paul, Shell Basics, not submitted
Babe, Shell Navigation, submitted 
Aubrey, Git, submitted
Ken, Shell Navigation, submitted
Fripong, Shell Basics, submitted 
Miquella, Git, not submitted 
EOF

cat > "$new_dir/config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF


cat > "$new_dir/startup.sh" << 'EOF'
#!/bin/bash
./app/reminder.sh
EOF

find "$new_dir" -type f -name "*.sh" -exec chmod +x {} \;
echo "Successfully created the directory '$new_dir'"
