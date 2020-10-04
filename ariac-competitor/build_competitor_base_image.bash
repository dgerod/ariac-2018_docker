#!/usr/bin/env bash
#
# Only works with ROS Kinetic
#

set -e

# Constants
ROS_DISTRO_BUILD_TIME=kinetic
UBUNTU_DISTRO_TO_BUILD=xenial

# Comment this line to rebuild using the cache
DOCKER_ARGS="--no-cache"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create a Dockerfile from the template
cp ${DIR}/ariac-competitor-base/Dockerfile_generic \
   ${DIR}/ariac-competitor-base/Dockerfile
# Set the proper base image in the Dockerfile according to the ROS distro
sed -i "s+^FROM.*$+FROM osrf/ros:${ROS_DISTRO_BUILD_TIME}-desktop-full+" \
   ${DIR}/ariac-competitor-base/Dockerfile


docker build ${DOCKER_ARGS} -t ariac-competitor-base-${ROS_DISTRO_BUILD_TIME}:latest ${DIR}/ariac-competitor-base
