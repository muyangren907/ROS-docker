FROM ubuntu:bionic-20200713

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO melodic
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
#ADD image /


RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common curl \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        firefox \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta \
        dbus-x11 x11-utils \
        terminator \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get update && apt-get install -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list \
    && apt-get update && apt-get install --no-install-recommends -y \
    python-rosinstall \
    python-vcstools \
	python-rosinstall-generator \
	python-wstool \
	build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get update && apt-get install -y \
    ros-melodic-desktop-full \
    && rm -rf /var/lib/apt/lists/* \
    && rosdep init \
    && rosdep update \
    && apt-get update && apt-get install -y \
    terminator \
    gedit \
    okular \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /bin/tini \
    && pip install setuptools wheel && pip install -r /usr/lib/web/requirements.txt \
    && cp /usr/share/applications/terminator.desktop /root/Desktop \
    && echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
