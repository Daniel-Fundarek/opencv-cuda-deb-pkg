#include <opencv2/core.hpp>
#include <opencv2/cudaimgproc.hpp>
#include <iostream>

int main() {
    int deviceCount = cv::cuda::getCudaEnabledDeviceCount();
    if (deviceCount == 0) {
        std::cout << "No CUDA-enabled devices found." << std::endl;
        return 1;
    }

    cv::cuda::printShortCudaDeviceInfo(0);
    return 0;
}
