#!/bin/bash

# Default path
path="."
hostname=$(hostname)

# Check if a path is provided
if [ $# -gt 0 ]; then
	path="$1"
fi

# Create necessary directories
mkdir -p "$path/$hostname/rpm/repos"
mkdir -p "$path/$hostname/apt/sources.list.d"
mkdir -p "$path/$hostname/homebrew"
mkdir -p "$path/$hostname/flatpak/repos"

# Backup apt packages
if command -v apt-get &>/dev/null; then
	# Apt-based distribution
	echo "Apt-based distribution detected."

	# Backup apt sources list
	echo "Backing up /etc/apt/sources.list to $path/$hostname/apt/sources.list"
	cp /etc/apt/sources.list "$path/$hostname/apt/sources.list"

	# Backup apt sources list directory
	echo "Backing up /etc/apt/sources.list.d/ to $path/$hostname/apt/sources.list.d/"
	cp -r /etc/apt/sources.list.d/ "$path/$hostname/apt/sources.list.d/"

	# List installed packages
	echo "Listing installed packages to $path/$hostname/apt/packages.txt"
	dpkg --get-selections | grep -v deinstall >"$path/$hostname/apt/packages.txt"
fi

# Backup RPM packages
if command -v yum &>/dev/null || command -v dnf &>/dev/null; then
	# RPM-based distribution
	echo "RPM-based distribution detected."

	# Backup yum repos
	echo "Backing up /etc/yum.repos.d/ to $path/$hostname/rpm/repos/"
	cp -r /etc/yum.repos.d/ "$path/$hostname/rpm/repos/"

	# List installed packages
	echo "Listing installed packages to $path/$hostname/rpm/packages.txt"
	rpm -qa --qf '%{Name}.%{Arch} ' >"$path/$hostname/rpm/packages.txt"
fi

# Backup Homebrew formulae and casks
if command -v brew &>/dev/null; then
	echo "Homebrew detected."

	# Backup Homebrew packages
	echo "Listing installed Homebrew packages to $path/$hostname/homebrew/"
	brew list --formula >"$path/$hostname/homebrew/formulae.txt"
	brew list --cask >"$path/$hostname/homebrew/casks.txt"
fi

# Backup Flatpak packages
if command -v flatpak &>/dev/null; then
	echo "Flatpak detected."

	# List installed Flatpak packages
	echo "Listing installed Flatpak packages to $path/$hostname/flatpak/packages.txt"
	flatpak list --columns=application >"$path/$hostname/flatpak/packages.txt"
fi

echo "Backup and package listing completed successfully."
