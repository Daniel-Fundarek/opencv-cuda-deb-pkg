#!/bin/bash

version=4.11.0

sudo apt-get update

sudo apt-get install -y \
  debhelper dh-python libjpeg-dev \
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
  libgoogle-glog-dev libgflags-dev \
  libgphoto2-dev libopenexr-dev libcharls2


if [ -f /etc/os-release ]; then
	# Source the /etc/os-release file to get variables
	. /etc/os-release
	# Extract the major version number from VERSION_ID
	VERSION_MAJOR=$(echo "$VERSION_ID" | cut -d'.' -f1)
	# Check if the extracted major version is 22 or earlier
	if [ "$VERSION_MAJOR" = "22" ] || [ "$VERSION_MAJOR" = "24" ]; then
		sudo apt-get install -y libswresample-dev libdc1394-dev
	else
	sudo apt-get install -y libavresample-dev libdc1394-22-dev
	fi
else
	sudo apt-get install -y libavresample-dev libdc1394-22-dev
fi
sudo apt install libjs-mathjax -y
sudo apt install libthrust-dev -y
sudo apt install curl -y

echo "Creating build folders"
if [ -d "./build" ]
then
	if [ -d "./build/opencv-$version" ]
	then
		rm -rf "./build/opencv-$version"
	fi
fi
mkdir -p ./build


echo ""

echo "Downloading and verifying OpenCV sources"
if [ -f "./build/opencv_$version.orig.tar.gz" ]
then
	echo "Existing OpenCV main source found - checking if correct"
	main_sum=$(sha256sum "./build/opencv_$version.orig.tar.gz" | cut -d ' ' -f 1)
	if ! [ "$main_sum" == "$sha256_main_source" ]
	then
		echo "Incorrect checksum - deleting existing OpenCV main source"
		rm -rf "./build/opencv_$version.orig.tar.gz"
	else
		echo "Existing version of OpenCV main source okay"
	fi
fi
if ! [ -f "./build/opencv_$version.orig.tar.gz" ] 
then
	echo "Downloading OpenCV main source"
	curl -L -o "./build/opencv_$version.orig.tar.gz" "https://github.com/opencv/opencv/archive/refs/tags/$version.tar.gz"
fi



if [ -f "./build/opencv_$version.orig-contrib.tar.gz" ] 
then
	echo "Existing OpenCV contrib source found - checking if correct"
	contrib_sum=$(sha256sum "./build/opencv_$version.orig-contrib.tar.gz" | cut -d ' ' -f 1)
	if ! [ "$contrib_sum" == "$sha256_contrib_source" ]
	then
		echo "Incorrect checksum - deleting existing OpenCV contrib source"
		rm -rf "./build/opencv_$version.orig-contrib.tar.gz"
	else
		echo "Existing version of OpenCV contrib source okay"
	fi
fi
if ! [ -f "./build/opencv_$version.orig-contrib.tar.gz" ]
then
	echo "Downloading contrib OpenCV source"
	curl -L -o "./build/opencv_$version.orig-contrib.tar.gz" "https://github.com/opencv/opencv_contrib/archive/refs/tags/$version.tar.gz"
fi

sudo apt-get remove -y libopencv libopencv-* libopencv4.2* 
sudo apt-get purge -y libopencv libopencv-* libopencv4.2*

sudo apt remove -y opencv-samples-data opencv-licenses

echo "Extracting sources"
cd build
tar xf opencv_$version.orig.tar.gz
tar xf opencv_$version.orig-contrib.tar.gz --directory ./opencv-$version/
mv ./opencv-$version/opencv_contrib-$version ./opencv-$version/contrib

echo "Copying build and packaging instructions"
cp -r ../debian ./opencv-$version/

cd ./opencv-$version/
echo "Building package"
fakeroot debian/rules binary

