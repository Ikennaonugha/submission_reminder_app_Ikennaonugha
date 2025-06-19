#!/bin/bash

# Prompts the user for their name
read -p "Enter a name: " name

# Define the new directory name based on user input
new_dir="submission_reminder_${name}"

# Check if a name was entered
if [[ -z "${name}" ]]; then
    echo "Error: Name field cannot be empty. Exiting..."
    exit 1 # Exit the script
fi

# Check if the directory already exists
if [[ -d "$new_dir" ]]; then
    echo "Directory '$new_dir' already exists."
    read -p "Do you wish to overwrite it? (Y/N): " overwrite_choice

    case "$overwrite_choice" in
        [yY])
            echo "Overwriting directory..."
            rm -rf "$new_dir" # Remove the existing directory and its contents
            ;;
        [nN])
            echo "Exiting without overwriting."
            exit 1 # Exit the script
            ;;
        *)
            echo "Invalid choice. Please answer Y or N."
            echo "Exiting without action."
            exit 1 # Exit the script due to invalid input
            ;;
    esac
fi

# Create the main directory
mkdir -p "$new_dir"

# Create necessary subdirectories
mkdir -p "$new_dir/app"
mkdir -p "$new_dir/modules"
mkdir -p "$new_dir/assets"
mkdir -p "$new_dir/config"

echo "Creating files and populating them..."

# Create and populate reminder.sh
cat > "$new_dir/app/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
# The 'source' command loads variables and functions into the current shell
# This ensures that ASSIGNMENT and DAYS_REMAINING are available
# and check_submissions function can be called.
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file, relative to the app's root directory
submissions_file="./assets/submissions.txt"

# Display assignment information to the user
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

# Call the function to check submissions
check_submissions "$submissions_file"
EOF

# Create and populate functions.sh
cat > "${new_dir}/modules/functions.sh" << 'EOF'
#!/bin/bash

# Function: check_submissions
# Purpose: Reads a submissions file and outputs students who have not submitted
# Arguments:
#   $1 - Path to the submissions file
function check_submissions {
    local submissions_file="$1" # Assign the first argument to a local variable
    echo "Checking submissions in $submissions_file"

    # Use tail -n +2 to skip the header line of the CSV
    # IFS=, sets the Internal Field Separator to comma for reading CSV
    # read -r reads each line, -r prevents backslash escapes from being interpreted
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace from each field using xargs (trimming)
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if the assignment matches the configured ASSIGNMENT (from config.env)
        # and if the submission status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            # Print a reminder for the student
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Process the output of tail
}
EOF

# Create and populate submissions.txt with at least 5 new student records
cat > "$new_dir/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Amirah, Git, not submitted
Kim, Shell Basics, submitted
De Paul, Shell Basics, not submitted
Babe, Shell Navigation, submitted
Aubrey, Git, submitted
Ken, Shell Navigation, submitted
Fripong, Shell Basics, submitted
Miquella, Git, not submitted
EOF

# Create and populate config.env
cat > "$new_dir/config/config.env" << 'EOF'
# This is the config file for the submission reminder application.
# ASSIGNMENT: The name of the assignment to check submissions for.
ASSIGNMENT="Shell Navigation"
# DAYS_REMAINING: The number of days remaining until the submission deadline.
DAYS_REMAINING=2
EOF

# Create and populate startup.sh
# This script will navigate to its parent directory (the app's root)
# before running the reminder.sh script to ensure correct paths.
cat > "$new_dir/startup.sh" << 'EOF'
#!/bin/bash

# Get the directory where the current script is located.
# BASH_SOURCE[0] is the path to the script itself.
# dirname gets the directory part of the path.
# cd into that directory.
# pwd prints the full path of the current directory.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Change the current working directory to the script's directory.
# This makes subsequent relative paths (like ./app/reminder.sh) correct.
cd "$SCRIPT_DIR" || { echo "Error: Could not change to script directory." >&2; exit 1; }

# Execute the main reminder application script.
# The './' ensures it's run as an executable in the current directory.
./app/reminder.sh
EOF

# Make all .sh files within the new_dir and its subdirectories executable
echo "Setting executable permissions for .sh files..."
find "$new_dir" -type f -name "*.sh" -exec chmod +x {} \;

echo "Successfully created the directory '$new_dir' and populated the files."
echo "You can now navigate into '$new_dir' or run './$new_dir/startup.sh' from here."
