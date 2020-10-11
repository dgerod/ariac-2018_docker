#!/usr/bin/env bash
#
# Only works with ROS Kinetic
#
set -e

# Constants
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NOCOLOR='\033[0m'

# Arguments
TEAM_NAME=$1

HOST_WORKSPACE_DIR="/home/dieesrod/Workspaces/ARIAC-2018/example_workspace"
WORKSPACE_DIR="/home/ariac-user/my_team_ws"

# Create the directory that logs will be copied into. Since the userid of the user in the container
# might different to the userid of the user running this script, we change it to be public-writable.
HOST_LOG_DIR=`pwd`/logs/${TEAM_NAME}/${TRIAL_NAME}
echo "Creating directory: ${HOST_LOG_DIR}"
mkdir -p ${HOST_LOG_DIR}
chmod 777 ${HOST_LOG_DIR}

# TODO: don't rely on script being run in the root directory
# TODO: error checking for case when files can't be found
TEAM_CONFIG_DIR=`pwd`/team_config/${TEAM_NAME}
echo "Using team config: ${TEAM_CONFIG_DIR}/team_config.yaml"
COMP_CONFIG_DIR=`pwd`/trial_config
echo "Using comp config: ${COMP_CONFIG_DIR}/${TRIAL_NAME}.yaml"

ROS_DISTRO=kinetic
LOG_DIR=/ariac/logs

# Ensure any previous containers are killed and removed.
./kill_ariac_containers.bash

# Create the network for the containers to talk to each other.
./ariac-competitor/ariac_network.bash

# Start the competition server. When the trial ends, the container will be killed.
# The trial may end because of time-out, because of completion, or because the user called the
# /ariac/end_competition service.
IMAGE_NAME="ariac-competitor-devel-${TEAM_NAME}"
CONTAINER_NAME="${IMAGE_NAME}-system"

echo -e "${GREEN}Starting docker container named '${CONTAINER}' with IP ${IP}...${NOCOLOR}"

./ariac-server/run_container.bash ${CONTAINER_NAME} ${IMAGE_NAME}:latest \
  "-v ${TEAM_CONFIG_DIR}:/team_config \
  -v ${COMP_CONFIG_DIR}:/ariac/trial_config \
  -v ${HOST_WORKSPACE_DIR}:${WORKSPACE_DIR} \
  -v ${HOST_LOG_DIR}:${LOG_DIR} \
  -e ARIAC_EXIT_ON_COMPLETION=1 \
  -p 6080:80"

./kill_ariac_containers.bash

# Copy the ROS log files from the competitor's container.
echo "Copying ROS log files from competitor container..."
docker cp --follow-link ${CONTAINER_NAME}:/root/.ros/log/latest $HOST_LOG_DIR/ros-competitor
echo -e "${GREEN}OK${NOCOLOR}"

./kill_ariac_containers.bash

exit 0
