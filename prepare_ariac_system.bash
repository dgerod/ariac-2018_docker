#!/bin/bash -x
#
# Only works with ROS kinetic 
#

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROS_DISTRO_TO_BUILD="kinetic"

echo "Preparing the ARIAC competition setup"

${DIR}/ariac-server/build_server_images.bash 'ariac-server-flatten'
${DIR}/ariac-competitor/build_competitor_base_image.bash
