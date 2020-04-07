# Kudos to DOROWU for his amazing VNC 16.04 KDE image
FROM dorowu/ubuntu-desktop-lxde-vnc
LABEL maintainer Arnaldo Viana

# Adding keys for ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Installing ROS
RUN apt-get update && apt-get install -y ros-kinetic-desktop-full \ 
		wget git nano
RUN apt-get install -y ros-kinetic-turtlebot3* 
RUN rosdep init && rosdep update

# Update Gazebo 7
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN apt-get update && apt-get install -y gazebo7 libignition-math2-dev


RUN /bin/bash -c "echo 'export HOME=/home/ubuntu' >> /root/.bashrc && source /root/.bashrc"

# Creating ROS_WS
RUN mkdir -p ~/catkin_ws/src

# Set up the workspace
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd ~/catkin_ws/ && \
                  catkin_make && \
                  echo 'export GAZEBO_MODEL_PATH=~/catkin_ws/src/my_simulation/models' >> ~/.bashrc && \
                  echo 'source ~/catkin_ws/devel/setup.bash' >> ~/.bashrc"

# Installing repo required for homework
RUN cd ~/catkin_ws/src && git clone https://github.com/arnaldojr/my_simulation.git && \
		git clone https://github.com/arnaldojr/mybot_description.git

# Updating ROSDEP and installing dependencies
RUN cd ~/catkin_ws && rosdep update && rosdep install --from-paths src --ignore-src --rosdistro=kinetic -y

# Sourcing
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd ~/catkin_ws/ && rm -rf build devel && \
                  catkin_make"

# Dunno about this one tbh
RUN /bin/bash -c "echo 'export GAZEBO_MODEL_PATH=~/catkin_ws/src/my_simulation/models' >> /root/.bashrc && \
                  echo 'source ~/catkin_ws/devel/setup.bash' >> /root/.bashrc"
