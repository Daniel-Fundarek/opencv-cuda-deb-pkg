# OpenCV build and packaging script for Debian/Ubuntu

Working with up to date version of OpenCV when using Debian or Ubuntu, both commonly used as basis for (docker) containers or VMs/cloud instances, is a bit tricky. This script provides an easy to use build instruction to create a (system-wide) `.deb` package suitable for the OS it was build with.

## Features

- all CUDA features are enabled            

## Instructions

Install and init git lfs:

```
    sudo apt-get install git-lfs
    git lfs install
```
Create and install deb package:

1. clone repository
2. fix dependecy version in control file, such as: cuda-libraries-dev-<version-subversion> -> example: cuda-libraries-dev-11-4
3. execute `./build_package.sh`
4. install `sudo apt install ./release/opencv-cuda_x.x.x-x_all.deb`
5. remove build folder (you may want to keep a backup of the `.deb` file built)

If you want to only install debian package:

1. clone repository
2. execute `./install_dependencies.sh`
3. install `sudo apt install ./build/opencv-cuda_x.x.x-x_all.deb`

Test opencv with cuda with:
```
    g++ -o test_cuda test_opencv_cuda.cpp `pkg-config --cflags --libs opencv4` -lopencv_core -lopencv_cudaimgproc
    ./test_cuda
```

## Other notes
- tested with `orin_nx`
- tested with `orin_nano`
