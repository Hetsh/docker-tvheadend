#!/usr/bin/env bash


# Abort on any error
set -e -u -o pipefail

# Simpler git usage, relative file paths
CWD=$(dirname "$0")
cd "$CWD"

# Load helpful functions
source libs/common.sh
source libs/docker.sh

# Check dependencies
assert_dependency "jq"
assert_dependency "curl"

# Updates
update_image "amd64/alpine" "\d{8}" "Alpine Linux"
update_packages_apk "hetsh/tvheadend"
if ! updates_available; then
	echo "No updates available."
	exit 0
fi

# Perform modifications
if test "${1-}" == "--noconfirm" || confirm_action "Save changes?"; then
	save_changes

	if test "${1-}" == "--noconfirm" || confirm_action "Commit changes?"; then
		commit_changes "tvheadend"
	fi
fi
