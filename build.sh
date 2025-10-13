#!/usr/bin/env bash


# Abort on any error
set -e -u -o pipefail

# Simpler git usage, relative file paths
CWD=$(dirname "$0")
cd "$CWD"

# Load helpful functions
source libs/common.sh
source libs/docker.sh

# Check access to docker daemon
assert_dependency "docker"
if ! docker version &> /dev/null; then
	echo "Docker daemon is not running or you have unsufficient permissions!"
	exit 1
fi

# Build image and export it's identifier to variable IMG_ID
function build_image {
	docker build .
	IMG_ID=$(docker build -q .)
}

# Find tags for this image and export them to variable TAGS
function find_tags {
	TAGS=("latest")

	# Account for git to be in detached head state
	local GIT_BRANCH && GIT_BRANCH="$(git branch --show-current)"
	if test -n "$GIT_BRANCH"; then
		GIT_BRANCH=$(basename "$GIT_BRANCH")
		TAGS+=("$GIT_BRANCH")
	fi

	# Account for multiple tags on the current commit
	for GIT_TAG in $(git tag --points-at); do
		GIT_TAG=$(basename "$GIT_TAG")
		TAGS+=("$GIT_TAG")
	done
}

# Tags the image with all tags that were found
function apply_tags {
	for TAG in "${TAGS[@]}"; do
		TAGGED_IMAGE="$IMG_NAME:$TAG"
		docker tag "$IMG_ID" "$TAGGED_IMAGE"
		echo "Tagged image: $TAGGED_IMAGE"
	done
}

IMG_NAME="hetsh/tvheadend"
TASK="${1-}"
case "$TASK" in
	# Build image and assign tags
	"--tag")
		build_image
		find_tags
		apply_tags
	;;
	# Build image and run test with default configuration
	"--test")
		build_image
		docker run \
			--rm \
			--tty \
			--interactive \
			--publish 9981:9981/tcp \
			--publish 9982:9982/tcp \
			--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
			"$IMG_ID"
	;;
	# Build and push tagged image
	"--upload")
		find_tags
		if tags_exist "$IMG_NAME" "${TAGS[@]}"; then
			echo "Image already exists, no need to upload!"
			exit 0
		fi

		build_image
		apply_tags
		for TAG in "${TAGS[@]}"; do
			docker push "$IMG_NAME:$TAG"
		done
	;;
	# Build image and output image identifier
	"")
		build_image
		echo "Build successful!"
		echo "The image has not been tagged!"
		echo "Use the image ID instead: $IMG_ID"
	;;
	# Catch and notify about unknown task
	*)
		echo_error "Unknown task \"$TASK\"!"
		exit 1
	;;
esac
