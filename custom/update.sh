#!/bin/bash
# shellcheck disable=SC2034

# This file will be sourced by scripts/update.sh to customize the update process


MAIN_ITEM="tvheadend"
GIT_VERSION="$(git describe --tags --first-parent --abbrev=0)"
update_image "amd64/alpine" "\\d{8}" "Alpine Linux"
update_packages_apk "hetsh/tvheadend"