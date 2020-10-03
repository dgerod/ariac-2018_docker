#!/usr/bin/env bash

set -e

TEAM_NAME=$1

COMPETITOR_IMAGE_NAME="ariac-competitor-${TEAM_NAME}-system"
docker container exec -it ${COMPETITOR_IMAGE_NAME} bash
