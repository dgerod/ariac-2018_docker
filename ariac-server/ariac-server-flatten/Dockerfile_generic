# -----------------------------------------------------
# Gazebo
# -----------------------------------------------------

# gzserver
# ------------------------------------------

FROM ubuntu:xenial

ARG UBUNTU_DISTRO_TO_BUILD=trusty

# Setup keys
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys D2486D2DD83DB69272AFE98867170598AF249743
# Setup sources.list
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable ${UBUNTU_DISTRO_TO_BUILD} main" > /etc/apt/sources.list.d/gazebo-latest.list

# Install gazebo packages
RUN apt-get update && apt-get install -q -y --allow-unauthenticated \
        gazebo8 \
        libgazebo8-dev && \
    rm -rf /var/lib/apt/lists/*

# Setup environment
EXPOSE 11345

# gazebo
# ------------------------------------------

ARG USERID=1000

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

# Install bootstrap tools
#     sudo \
RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated \
        bash-completion \
        git \
        wget \
        locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a new user called ariac. Note: we don't add them to the sudo group
ENV USERNAME ariac
RUN locale-gen en_US.UTF-8
RUN adduser -u $USERID --gecos "Development User" --disabled-password $USERNAME
RUN echo "export QT_X11_NO_MITSHM=1" >> /home/$USERNAME/.bashrc

USER $USERNAME
WORKDIR /home/$USERNAME

# Get gazebo models by cloning repository
# Do it early since it's big
RUN git clone https://github.com/osrf/gazebo_models $HOME/.gazebo/models

# -----------------------------------------------------
# ROS (gazebo-ros)
# -----------------------------------------------------
# Instructions derived from https://github.com/osrf/docker_images/tree/master/ros

ARG UBUNTU_DISTRO_TO_BUILD
ARG ROS_DISTRO_BUILD_TIME

USER root

# Setup ROS keys
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116
# Setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu ${UBUNTU_DISTRO_TO_BUILD} main" > /etc/apt/sources.list.d/ros-latest.list

# Install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# Bootstrap rosdep
RUN rosdep init \
    && rosdep update

# Install ros packages
ENV ROS_DISTRO ${ROS_DISTRO_BUILD_TIME}
RUN apt-get update && apt-get install -y --allow-unauthenticated \
    ros-${ROS_DISTRO_BUILD_TIME}-ros-core \
    ros-${ROS_DISTRO_BUILD_TIME}-ros-base \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------
# ARIAC 2018 (ariac-server)
# -----------------------------------------------------

ARG ROS_DISTRO_BUILD_TIME

USER root

# Install the ariac package
RUN apt-get update && apt-get install -y --allow-unauthenticated \
        ros-${ROS_DISTRO_BUILD_TIME}-ros-controllers \
        ros-${ROS_DISTRO_BUILD_TIME}-robot-state-publisher \
        ariac2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Needed to use killall
RUN apt-get update && apt-get install -y --allow-unauthenticated \
        psmisc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Need to install a specific version of gazebo_ros_pkgs
# 1. Remove official packages
RUN export GZ_VERSION=8 && \
    dpkg -r --force-depends ros-${ROS_DISTRO_BUILD_TIME}-gazebo${GZ_VERSION}-ros-pkgs \
                            ros-${ROS_DISTRO_BUILD_TIME}-gazebo${GZ_VERSION}-ros \
                            ros-${ROS_DISTRO_BUILD_TIME}-gazebo${GZ_VERSION}-plugins \
                            ros-${ROS_DISTRO_BUILD_TIME}-gazebo${GZ_VERSION}-msgs \
                            ros-${ROS_DISTRO_BUILD_TIME}-gazebo${GZ_VERSION}-ros-control

# 2. Build the version from source
RUN mkdir -p /tmp/ros_ws/src
RUN /bin/bash -c "source /opt/ros/${ROS_DISTRO_BUILD_TIME}/setup.bash && \
                  cd /tmp/ros_ws/src && \
                  catkin_init_workspace"
RUN git clone \
      https://github.com/ros-simulation/gazebo_ros_pkgs /tmp/ros_ws/src/gazebo_ros_pkgs \
      -b ariac-network-${ROS_DISTRO_BUILD_TIME}
RUN /bin/bash -c "source /opt/ros/${ROS_DISTRO_BUILD_TIME}/setup.bash && \
                  cd /tmp/ros_ws/ && \
                  catkin_make -DCMAKE_INSTALL_PREFIX=/opt/ros/${ROS_DISTRO_BUILD_TIME} -j2 install "

# -----------------------------------------------------
# Entry point
# -----------------------------------------------------

COPY ./ariac_entrypoint.sh /
COPY ./run_ariac_task.sh /

USER $USERNAME
ENTRYPOINT ["/ariac_entrypoint.sh"]
