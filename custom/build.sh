#!/bin/bash
# shellcheck disable=SC2034

# This file will be sourced by scripts/build.sh to customize the build process

IMG_NAME="hetsh/tvheadend"
function test_image {
	docker run \
		--rm \
		--publish 9981:9981/tcp \
		--publish 9982:9982/tcp \
		--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
		"$IMG_ID"
}
