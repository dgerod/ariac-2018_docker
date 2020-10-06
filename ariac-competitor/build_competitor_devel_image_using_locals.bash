#!/usr/bin/env bash
#
# Only works with ROS Kinetic
#

set -x

# Constants
ROS_DISTRO_BUILD_TIME=kinetic
UBUNTU_DISTRO_TO_BUILD=xenial

# Arguments
TEAM_NAME=$1
DOCKER_ARGS=$2

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# TODO: pass the path of the team's scripts as a parameter of the Dockerfile,
# instead of copying them temporarily so they always have the same location.
echo "Copying team scripts temporarily"
cp ${TEAM_CONFIG_DIR}/build_team_system.bash ${DIR}/ariac-competitor/build_team_system.bash
cp ${TEAM_CONFIG_DIR}/run_team_system.bash ${DIR}/ariac-competitor/run_team_system.bash

cp ${DIR}/ariac-competitor-devel/Dockerfile_generic \
   ${DIR}/ariac-competitor-devel/Dockerfile

echo "Build the image"
docker build ${DOCKER_ARGS} -t ariac-competitor-devel-${TEAM_NAME}:latest ${DIR}/ariac-competitor-devel

echo "Removing temporary team scripts"
rm ${DIR}/ariac-competitor/build_team_system.bash
rm ${DIR}/ariac-competitor/run_team_system.bash
