#!/usr/bin/env bash

set -e

TEAM_NAME=$1
CONTAINER_NAME="ariac-competitor-devel-${TEAM_NAME}-system"

docker cp \
       /home/dieesrod/Workspaces/ARIAC-2018/ariac_iiwa/iiwa_moveit/config/iiwa14.srdf \
       ${CONTAINER_NAME}:/opt/ros/kinetic/share/iiwa_moveit/config/

docker cp \
       /home/dieesrod/Workspaces/ARIAC-2018/ariac_source/osrf_gear/launch/arm_extra_sensors/ \
       ${CONTAINER_NAME}:/opt/ros/kinetic/share/osrf_gear/launch/arm_extra_sensors/

docker cp \
       /home/dieesrod/Workspaces/ARIAC-2018/ariac_source/osrf_gear/launch/gear.urdf.xacro.template \
       ${CONTAINER_NAME}:/opt/ros/kinetic/share/osrf_gear/launch/
