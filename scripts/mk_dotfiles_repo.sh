#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <destination_directory>"
	exit 1
fi

DEST_DIR=$1
DOTFILES_PATH="$HOME/Utilities/dotfiles"
SCRIPTS_PATH="$HOME/Utilities/scripts"
DOCKER_FILES_PATH="$HOME/Utilities/services"
PACKAGES_PATH="$HOME/Utilities/packages"

FILES=(
	"$DOCKER_FILES_PATH"
	"$DOTFILES_PATH"
	"$SCRIPTS_PATH"
	"$PACKAGES_PATH"
	# Add as neded
)

if [ ! -d "$DEST_DIR" ]; then
	echo "Destination directory '$DEST_DIR' does not exist."
	exit 1
fi

# Copy files to destination directory
for FILE in "${FILES[@]}"; do
	if [ -d "$FILE" ]; then
		cp -r "$FILE" "$DEST_DIR"
	elif [ -f "$FILE" ]; then
		cp "$FILE" "$DEST_DIR"
	else
		echo "Warning: $FILE does not exist and will not be copied."
	fi
done

# Go to destination directory
cd "$DEST_DIR" || {
	echo "Failed to change directory to '$DEST_DIR'"
	exit 1
}

# Add all changes to git
git add .

# Run gitleaks to verify there are no secrets
gitleaks detect --verbose
if [ $? -ne 0 ]; then
	echo "Gitleaks detected secrets. Please review and fix them before committing."
	exit 1
fi

# Get the current timestamp in format "DD-MM-YYYY  HH:MM"
TIMESTAMP=$(date +"%d-%m-%Y  %H:%M")

# Commit the changes with the timestamp as the commit message
git commit -m "Back up dotfiles - $TIMESTAMP"

# Check if the commit was successful
if [ $? -eq 0 ]; then
	echo "Changes committed successfully."
else
	echo "Failed to commit changes."
	exit 1
fi
