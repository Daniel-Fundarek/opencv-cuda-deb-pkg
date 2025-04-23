#!/bin/bash

version=4.9.0
sha256_main_source="ddf76f9dffd322c7c3cb1f721d0887f62d747b82059342213138dc190f28bc6c"
sha256_contrib_source="8952c45a73b75676c522dd574229f563e43c271ae1d5bbbd26f8e2b6bc1a4dae"

sudo apt-get update
sudo apt-get install debhelper
sudo apt-get install dh-python

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
	main_sum=$(sha256sum "./build/opencv_$version.orig.tar.gz" | cut -d ' ' -f 1)
fi
if ! [ "$main_sum" == "$sha256_main_source" ]
then
	echo "OpenCV main source downloaded does not match checksum"
	echo "Deleting build folder"
	rm -rf "./build"
	exit 1
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
	contrib_sum=$(sha256sum "./build/opencv_$version.orig-contrib.tar.gz" | cut -d ' ' -f 1)
fi
if ! [ "$contrib_sum" == "$sha256_contrib_source" ]
then
	echo "OpenCV contrib source does not match checksum"
	echo "Deleting build folder"
	rm -rf "./build"
	exit 1
fi

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

