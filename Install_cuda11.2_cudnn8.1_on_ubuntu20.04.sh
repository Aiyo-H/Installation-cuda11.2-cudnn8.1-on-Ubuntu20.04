# This file shows how to install cuda v11.2 and cudnn8.1 in Ubuntu 20.04
# I have tried many method, this one works for me

# Steps:
# Remove previous installation if need
# Verify the system has a cuda-capable gpu
# Download and install the nvidia cuda toolkit and cudnn
# Setup environmental variables
# Verify the installation

# Remove previous installation.
# If you don't have previous installation, skip this step
sudo apt-get purge nvidia*
sudo apt remove nvidia-*
sudo rm /etc/apt/sources.list.d/cuda*
sudo apt-get autoremove && sudo apt-get autoclean
sudo rm -rf /usr/local/cuda*


# Verify your gpu is cuda enable check
lspci | grep -i nvidia

# System update
sudo apt-get update
sudo apt-get upgrade

# Install other import packages
sudo apt-get install gcc g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev

# First get the PPA repository driver
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update

# Install nvidia driver with dependencies
sudo apt install libnvidia-common-470
sudo apt install libnvidia-gl-470
sudo apt install nvidia-driver-470

# Follow the instruction provided by the nvidia website
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.2.0/local_installers/cuda-repo-ubuntu2004-11-2-local_11.2.0-460.27.04-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-2-local_11.2.0-460.27.04-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu2004-11-2-local/7fa2af80.pub
sudo apt-get update
# Here, the website used 'sudo apt-get -y install cuda' but I found out that if I do the same, the cuda 12.2 will be installed
# So I specifiedd the version here
sudo apt-get -y install cuda-11-2

# Setup paths
echo 'export PATH=/usr/local/cuda-11.2/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
sudo ldconfig

# Install cuDNN v8.1
# Here directly download the cudnn tgz file from the website: https://developer.nvidia.com/cudnn
# Go to the archive: Download cuDNN v8.1.1 (Feburary 26th, 2021), for CUDA 11.0,11.1 and 11.2
# Click the option: cuDNN Library for Linux (x86_64)
# The file with the name 'cudnn-11.2-linux-x64-v8.1.1.33.tgz' will be downloaded
CUDNN_TAR_FILE="cudnn-11.2-linux-x64-v8.1.1.33.tgz"
tar -xzvf ${CUDNN_TAR_FILE}

# Copy the following files into the cuda toolkit directory.
# If it said file not found, it might be that your 'cuda' file is inside the Downloads dir and you are in Home dir
# Move the file or cd to the file location
sudo cp -P cuda/include/cudnn.h /usr/local/cuda-11.2/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda-11.2/lib64/
sudo chmod a+r /usr/local/cuda-11.2/lib64/libcudnn*

# Finally, you can verify you installation
# But you might need to reboot first to use the command.
nvidia-smi
nvcc -V