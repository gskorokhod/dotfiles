#!/bin/bash

# ---- PRIVATE FILES - These should not be shared publicly! ------
# List of files to copy to the /dotfiles/<user> directory
# The /./ indicates the part of the path for rsync --relative to use. We're using it to strip "/home/<user>".
PRIVATE_FILES=(
	"$HOME/./.ssh"
	"$HOME/./.bash"
	"$HOME/./.bashrc"
	"$HOME/./.gitconfig"
	"$HOME/./.config"
	"$HOME/./.mozilla"
	"$HOME/./.tmux.conf"
)

# Regexes to exclude for the above files
PRIVATE_EXCLUDE_PATTERNS=(
	"*cache*" # Don't want to back up caches
	"*Cache*"
	"*.tmp"
	"*__pycache__*"
	"*qemu/save*" # Saved VM state
	"*unity3d*"   # For me that was just saves & caches for some games - not terribly useful
)

PRIVATE_DESTINATION="$HOME/Utilities/dotfiles/$USER"
# ----------------------------------------------------------------

# ---- PUBLIC FILES - These can be shared on github --------------
# List of files to copy to the /dotfiles/dotfiles_public directory
PUBLIC_FILES=(
	"$HOME/./.ssh/id_rsa.pub"
	"$HOME/./.ssh/config"
	"$HOME/./.bash"
	"$HOME/./.bashrc"
	"$HOME/./.gitconfig"
	"$HOME/./.config/nvim"
	"$HOME/./.config/gh"
	"$HOME/./.tmux.conf"
)

# Regexes to exclude for the above files
PUBLIC_EXCLUDE_PATTERNS=(
	"*cache*" # Don't want to back up caches
	"*Cache*"
	"*.tmp"
	"*__pycache__*"
	"*qemu/save*" # Saved VM state
	"*unity3d*"   # For me that was just saves & caches for some games - not terribly useful
	"*.pem"       # Try to catch some obviously sensitive files.
	"*.cer"       # This is not very effective at all and you should mostly be conservative with setting PUBLIC_FILES
	"*.env"
	"*.p12"
	"*.pfx"
	"*key*"
	"*credentials*"
	"*pass*"
	"*access*"
)

PUBLIC_DESTINATION="$HOME/Utilities/dotfiles/dotfiles_public"
# ----------------------------------------------------------------

copy_files() {
	local source_files=()
	local exclude_patterns=()
	local destination=""

	# Parse named arguments
	while [[ "$#" -gt 0 ]]; do
		case $1 in
		-f | --files)
			shift
			while [[ "$1" != "-"* && "$#" -gt 0 ]]; do
				source_files+=("$1")
				shift
			done
			;;
		-e | --exclude)
			shift
			while [[ "$1" != "-"* && "$#" -gt 0 ]]; do
				exclude_patterns+=("$1")
				shift
			done
			;;
		-d | --destination)
			destination="$2"
			shift 2
			;;
		*)
			echo "Unknown parameter: $1"
			exit 1
			;;
		esac
	done

	# Prepare the exclude options for rsync
	local exclude_options=()
	for pattern in "${exclude_patterns[@]}"; do
		exclude_options+=("--exclude=$pattern")
	done

	# Make destination directory
	mkdir -p "${destination}"

	# Sync the files using rsync
	rsync -av --relative "${exclude_options[@]}" "${source_files[@]}" "${destination}"

	echo ""
	echo "Files have been copied to $destination"
	echo "Checking for leaked secrets..."
	gitleaks detect --no-git -s "${destination}"
	echo ""
}

# Copy private files
copy_files -f "${PRIVATE_FILES[@]}" -e "${PRIVATE_EXCLUDE_PATTERNS[@]}" -d "$PRIVATE_DESTINATION"

# Gitignore private dotfiles, just so they aren't accidentally added to a dotfiles repo
echo "/*" >"$PRIVATE_DESTINATION/.gitignore"

# Add a warning message too
cat <<EOF >"$PRIVATE_DESTINATION/DO_NOT_SHARE.md"
# WARNING: DO NOT SHARE

This directory contains sensitive dotfiles that may expose private keys, credentials, or other sensitive information.

Only share files from the public dotfiles directory located at:

$PUBLIC_DESTINATION
EOF

# Copy public files
copy_files -f "${PUBLIC_FILES[@]}" -e "${PUBLIC_EXCLUDE_PATTERNS[@]}" -d "$PUBLIC_DESTINATION"

echo "All done!"
