#!/bin/bash
set -e

# -------------------------------------------------
# ariac
# -------------------------------------------------

# first, execute overriden entrypoint from gazebo
source "/usr/share/gazebo/setup.sh"

# setup ros environment. Ignore redifiniton of ROS_DISTRO
source "/opt/ros/${ROS_DISTRO}/setup.bash" > /dev/null

# setup ariac environment
source "/opt/ros/${ROS_DISTRO}/etc/catkin/profile.d/99_osrf_gear_setup.sh"
echo "ariac entrypoint executed"

# run gear
# TODO: optionally disable this so a gzclient can be run on the host for development.
export GAZEBO_IP=127.0.0.1
export GAZEBO_IP_WHITE_LIST=127.0.0.1

# -------------------------------------------------
# vnc
# -------------------------------------------------

mkdir -p /var/run/sshd
chown -R root:root /root
mkdir -p /root/.config/pcmanfm/LXDE/
cp /usr/share/doro-lxde-wallpapers/desktop-items-0.conf /root/.config/pcmanfm/LXDE/

cd /usr/lib/web && ./run.py > /var/log/web.log 2>&1 &
nginx -c /etc/nginx/nginx.conf
exec /bin/tini -- /usr/bin/supervisord -n
