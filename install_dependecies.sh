sudo apt-get update

if [ -f /etc/os-release ]; then
	# Source the /etc/os-release file to get variables
	. /etc/os-release
	# Extract the major version number from VERSION_ID
	VERSION_MAJOR=$(echo "$VERSION_ID" | cut -d'.' -f1)
	# Check if the extracted major version is 22 or earlier
	if [ "$VERSION_MAJOR" = "22" ]; then
		sudo apt-get install -y libswresample-dev libdc1394-dev
	else
	sudo apt-get install -y libavresample-dev libdc1394-22-dev
	fi
else
	sudo apt-get install -y libavresample-dev libdc1394-22-dev
fi

sudo apt-get install -y \
  debhelper dh-python  nvidia-jetpack libjpeg-dev \
  libjpeg8-dev libjpeg-turbo8-dev \
  libpng-dev libtiff-dev libglew-dev \
  libavcodec-dev libavformat-dev libswscale-dev \
  libgtk2.0-dev libgtk-3-dev libcanberra-gtk* \
  python3-pip \
  libxvidcore-dev libx264-dev \
  libtbb-dev libxine2-dev \
  libv4l-dev v4l-utils qv4l2 \
  libtesseract-dev libpostproc-dev \
  libvorbis-dev \
  libfaac-dev libmp3lame-dev libtheora-dev \
  libopencore-amrnb-dev libopencore-amrwb-dev \
  libopenblas-dev libatlas-base-dev libblas-dev \
  liblapack-dev liblapacke-dev libeigen3-dev gfortran \
  libhdf5-dev libprotobuf-dev protobuf-compiler \
  libgoogle-glog-dev libgflags-dev

sudo apt-get remove -y libopencv libopencv-* libopencv4.2*
sudo apt-get purge -y libopencv libopencv-* libopencv4.2*

sudo apt install libjs-mathjax -y
sudo apt install libthrust-dev -y
