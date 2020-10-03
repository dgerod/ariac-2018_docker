#!/usr/bin/env bash

set -e

SERVER_IMAGE_NAME="ariac-server-system"
docker container exec -it ${SERVER_IMAGE_NAME} bash
