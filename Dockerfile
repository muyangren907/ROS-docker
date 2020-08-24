# This is a Dockerfile for muyangren907/ros:kinetic
FROM ubuntu:xenial-20200807
LABEL author="muyangren907"

USER root
# setup timezone
RUN echo 'Asia/Shanghai' > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata sudo git zsh nano gcc && \
    apt-get install -q -y --no-install-recommends --reinstall ca-certificates && \
    useradd ros -m && \
    echo ros:ros | chpasswd && \
    adduser ros sudo && \
    git clone https://github.com/muyangren907/ohmyzsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh && \
    rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros1-latest.list

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ROS_DISTRO kinetic

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-kinetic-desktop-full \
    python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc \
    && echo "source /opt/ros/kinetic/setup.zsh" >> ~/.zshrc \
    && rosdep init
USER ros

RUN git clone https://github.com/muyangren907/ohmyzsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# setup workdir
WORKDIR /home/ros
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc \
    && echo "source /opt/ros/kinetic/setup.zsh" >> ~/.zshrc \
    && rosdep update
    
CMD ["zsh"]
