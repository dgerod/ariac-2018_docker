#!/bin/bash
#
# Only works with ROS kinetic 
#

set -e

ROS_DISTRO=kinetic

echo "Pulling the ARIAC competition images from dockerhub"
docker pull ariac/ariac2-server-${ROS_DISTRO}:latest
docker pull ariac/ariac2-competitor-base-${ROS_DISTRO}:latest
