✨ Submission Reminder Application ✨
Welcome to the Submission Reminder Application! This project provides a robust, shell-script-based solution to help track and remind students about their pending assignment submissions. It's designed for ease of setup, flexible usage, and clear tracking.

🚀 Project Overview
The submission_reminder_app is a lightweight yet effective tool built with shell scripts. Its core function is to read student submission statuses from a submissions.txt file and highlight students who have not yet submitted a specific, configured assignment.

🌟 Key Features
Automated Environment Setup: 🛠️ The create_environment.sh script handles everything, from directory creation to populating essential application files.

Efficient Submission Tracking: 📚 The main application script (reminder.sh) intelligently processes submissions.txt to identify and list non-submitting students.

Flexible Assignment Configuration: ⚙️ The target assignment name is stored in config.env, allowing for easy modification to suit different assignments.

Dynamic Assignment Updates: 🔄 A dedicated utility script (copilot_shell_script.sh) empowers users to effortlessly change the target assignment name in the configuration and immediately re-run the reminder.

Secure Permissions: ✅ The setup script automatically ensures all .sh files are granted executable permissions for smooth operation.

📂 Directory Structure
When you execute create_environment.sh, it will generate a main directory named submission_reminder_{yourName} (where {yourName} is your input). Inside this, you'll find the following well-organized structure:

submission_reminder_{yourName}/
├── app/
│   └── reminder.sh           # 📝 Main application logic for reminders
├── assets/
│   └── submissions.txt       # 📋 Sample student submission records
├── config/
│   └── config.env            # 🛠️ Configuration variables (ASSIGNMENT, DAYS_REMAINING)
├── modules/
│   └── functions.sh          # 🧩 Reusable helper functions
└── startup.sh                # 🚀 Entry point to launch the reminder application


💡 Usage Guide
1. Running the Submission Reminder
Once your environment is set up, you can easily activate the reminder application:

./submission_reminder_{yourName}/startup.sh

(Don't forget to replace {yourName} with the name you provided during setup!)

This command will execute startup.sh, which in turn launches reminder.sh. The application will then cross-reference submissions.txt with the ASSIGNMENT defined in config.env and print out reminders for all students who have not yet submitted.

2. Changing the Assignment Name
Need to check submissions for a different assignment? The copilot_shell_script.sh makes it simple:

Run the copilot utility script:

./copilot_shell_script.sh

When prompted, enter the new assignment name (e.g., "Git").

The script will efficiently update the ASSIGNMENT variable in the config/config.env file within your application directory.

As an added convenience, the script will automatically re-run startup.sh immediately after the update. This means you'll see the submission status for the newly specified assignment without any extra steps!

All other application-specific files (e.g., the app/, assets/, config/, modules/ directories, and startup.sh) are considered generated assets. They are created by create_environment.sh and should NOT be directly committed to the main branch. This keeps the main branch clean, focused on setup and utility, and ensures the environment is always built from scratch.
