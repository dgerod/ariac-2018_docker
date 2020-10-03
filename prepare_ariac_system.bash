#!/bin/bash -x
#
# Only works with ROS kinetic 
#

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROS_DISTRO_TO_BUILD="kinetic"

echo "Preparing the ARIAC competition setup"

${DIR}/ariac-server/build-images.sh ${ROS_DISTRO_TO_BUILD}
${DIR}/ariac-competitor/build_competitor_base_image.bash ${ROS_DISTRO_TO_BUILD}
