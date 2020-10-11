# ARIAC 2018

Containerization of ARIAC 2018 competition server and competitors' code. See https://bitbucket.org/osrf/ariac/wiki/2018/Home

This repository contains the setup that will be used to automatically evaluate teams' submission for the Agile Robotics for Industrial Automation Competition (ARIAC) hosted by the National Institute of Standards and Technology (NIST).

This repository is a modification of https://github.com/osrf/ariac-docker. Main differences:
    
 * It only works with ROS Kinetic, any reference to other ROS versions have been removed.
 * A server flatten image has been added. So, other server images are not needed although they already exit.
 * A competitor image for development has been added. This image has VNC so Gazebo and other graphic tools could be used.

For more information read:
 * [ARIAC Automatic Evaluation](README_EVALUATION.md)
 * [Developement information](README_DEVELOPER.md)
