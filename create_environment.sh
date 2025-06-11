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



#creating directory structure
mkdir -p "${new_directory}/app/"
mkdir -p "${new_directory}/modules/"
mkdir -p "${new_directory}/assets/"
mkdir -p "${new_directory}/config/"


