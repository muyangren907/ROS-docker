#!/bin/bash
set -e

# setup ros environment
# source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/opt/ros/$ROS_DISTRO/setup.zsh"
exec "$@"
