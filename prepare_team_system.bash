#!/usr/bin/env bash

# Constants
YELLOW='\033[0;33m'
NOCOLOR='\033[0m'

# Arguments
TEAM_NAME=${1}

if [[ $# -lt 1 ]]; then
  echo "$0 <team-image-dir-name> [--use-cache]"
  exit 1
fi

if [[ ! -d team_config/${TEAM_NAME} ]]; then
  echo "Can not find team directory in 'team_config' directory: ${TEAM_NAME}"
  exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# By default, don't use the Docker cache so that team's systems are always using
# the most recent packages.
EXTRA_DOCKER_ARGS="--no-cache"

if [[ $# -gt 1 ]]; then
  case ${2} in
    "--use-cache")
      EXTRA_DOCKER_ARGS=""
      echo -e "${YELLOW}Wrn: Docker cache will be used.
       Beware that the image may be using out of date packages!${NOCOLOR}"
      sleep 2
      ;;
    *)
      echo "Unsupported argument: ${2}"
      exit 1
  esac
fi

echo "Preparing the team system setup for team ${TEAM_NAME}"
if [[ $# -lt 1 ]]; then
  echo "$0 "
  exit 1
fi

${DIR}/ariac-competitor/build_competitor_image_using_locals.bash ${TEAM_NAME} ${EXTRA_DOCKER_ARGS}
