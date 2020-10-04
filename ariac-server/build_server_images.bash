#!/bin/bash -x
#
# Only works with ROS kinetic
#

set -e

# Uncoment this line to rebuild without cache
#DOCKER_ARGS="--no-cache"

set -x

# Constants
ROS_DISTRO_BUILD_TIME=kinetic
UBUNTU_DISTRO_TO_BUILD=xenial

# Arguments
if [[ $# -lt 1 ]]; then
  echo "$0 <image-to-build [all|ariac-server-flatten|ariac-server-vnc|...]>"
  exit 1
else
  if [[ $1 == 'all' ]]; then
    DOCKER_IMAGES="gzserver gazebo gazebo-ros nvidia-gazebo-ros ariac-server ariac-server-flatten ariac-server-vnc"
  else
    DOCKER_IMAGES=$1
  fi
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Build all images requested
for docker_img in ${DOCKER_IMAGES}; do
  echo " Build image: ${docker_img} "

  case ${docker_img} in
    'ariac-server-vnc')
      DOCKER_ARGS="--no-cache --build-arg ROS_DISTRO_BUILD_TIME=${ROS_DISTRO_BUILD_TIME}"
      ;;
    'ariac-server-flatten')
      USERID=`id -u $USER`
      # If the script is run by root, do no pass 0 as the USERID to create the
      # ariac-user. The Dockerfile defaults it to 1000
      if [[ ${USERID} != 0 ]]; then
        DOCKER_ARGS="--no-cache \
                     --build-arg USERID=${USERID} \
                     --build-arg ROS_DISTRO_BUILD_TIME=${ROS_DISTRO_BUILD_TIME} \
                     --build-arg UBUNTU_DISTRO_TO_BUILD=${UBUNTU_DISTRO_TO_BUILD}"
      else 
        DOCKER_ARGS="--no-cache \
                     --build-arg ROS_DISTRO_BUILD_TIME=${ROS_DISTRO_BUILD_TIME} \
                     --build-arg UBUNTU_DISTRO_TO_BUILD=${UBUNTU_DISTRO_TO_BUILD}"
      fi
      ;;      
    'ariac-server')
      DOCKER_ARGS="--no-cache --build-arg ROS_DISTRO_BUILD_TIME=${ROS_DISTRO_BUILD_TIME}"
      ;;
    'gazebo')
      USERID=`id -u $USER`
      # If the script is run by root, do no pass 0 as the USERID to create the
      # ariac-user. The Dockerfile defaults it to 1000
      if [[ ${USERID} != 0 ]]; then
        DOCKER_ARGS="--build-arg USERID=${USERID}"
      fi
      ;;
    'gazebo-ros')
      DOCKER_ARGS="--build-arg ROS_DISTRO_BUILD_TIME=${ROS_DISTRO_BUILD_TIME} \
                   --build-arg UBUNTU_DISTRO_TO_BUILD=${UBUNTU_DISTRO_TO_BUILD}"
      ;;
    'gzserver')
      DOCKER_ARGS="--build-arg UBUNTU_DISTRO_TO_BUILD=${UBUNTU_DISTRO_TO_BUILD}"
      ;;
    *)
      DOCKER_ARGS=""
  esac

  # Set the proper base image in the Dockerfile according to the ROS distro
  cp ${DIR}/${docker_img}/Dockerfile_generic \
      ${DIR}/${docker_img}/Dockerfile

  if [ ${docker_img} = "gzserver" ]; then
    sed -i "s+^FROM.*$+FROM ubuntu:${UBUNTU_DISTRO_TO_BUILD}+" \
      ${DIR}/${docker_img}/Dockerfile
  #elif [ ${docker_img} = "ariac-server-flatten" ]; then
  #  sed -i "s+^FROM.*$+FROM ubuntu:${UBUNTU_DISTRO_TO_BUILD}+" \
  #    ${DIR}/${docker_img}/Dockerfile
  else
    sed -i "s/:latest/-${ROS_DISTRO_BUILD_TIME}:latest/" \
      ${DIR}/${docker_img}/Dockerfile
  fi

  # Tag the image according to the ROS distro
  docker build ${DOCKER_ARGS} \
    --tag ${docker_img}-${ROS_DISTRO_BUILD_TIME}:latest \
      $DIR/${docker_img}
done
