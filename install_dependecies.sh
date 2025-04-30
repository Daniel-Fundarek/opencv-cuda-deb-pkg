sudo apt-get update
sudo apt-get install -y debhelper 
sudo apt-get install -y dh-python 

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

sudo apt-get install -y nvidia-jetpack
sudo apt-get install -y libjpeg-dev libjpeg8-dev libjpeg-turbo8-dev
sudo apt-get install -y libpng-dev libtiff-dev libglew-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y libgtk2.0-dev libgtk-3-dev libcanberra-gtk*
sudo apt-get install -y python3-pip
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y libtbb-dev libxine2-dev
sudo apt-get install -y libv4l-dev v4l-utils qv4l2
sudo apt-get install -y libtesseract-dev libpostproc-dev
sudo apt-get install -y libvorbis-dev
sudo apt-get install -y libfaac-dev libmp3lame-dev libtheora-dev
sudo apt-get install -y libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt-get install -y libopenblas-dev libatlas-base-dev libblas-dev
sudo apt-get install -y liblapack-dev liblapacke-dev libeigen3-dev gfortran
sudo apt-get install -y libhdf5-dev libprotobuf-dev protobuf-compiler
sudo apt-get install -y libgoogle-glog-dev libgflags-dev
sudo apt install libjs-mathjax -y
sudo apt install libthrust-dev -y
