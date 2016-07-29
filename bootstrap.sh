#!/bin/bash

# Get utils
sudo apt-get -y install unzip wget tar make

# Ensure we are in home directory
cd ~

# Get the sdk and unpack
echo -e "\e[36mDOWNLOADING AND UNPACKING SDK\e[0m"
wget --quiet http://www.nordicsemi.com/eng/nordic/download_resource/54280/47/11303067 -O nRF5-SDK.zip
mkdir sdk
cp nRF5-SDK.zip sdk/
cd sdk
unzip nRF5-SDK.zip &> /dev/null
rm nRF5-SDK.zip
cd ..

# Get the ARM compiler toolchain
echo -e "\e[36mDOWNLOADING AND UNPACKING ARM TOOLCHAIN\e[0m"
wget --quiet https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q2-update/+download/gcc-arm-none-eabi-5_4-2016q2-20160622-linux.tar.bz2
tar xf gcc-arm-none-eabi-5_4-2016q2-20160622-linux.tar.bz2 &>/dev/null

# Get nRF5x tools
echo -e "\e[36mDOWNLOADING AND UNPACKING nRF5x TOOLS\e[0m"

# wget --quiet http://www.nordicsemi.com/eng/nordic/download_resource/51386/15/36025835 -O nRF5-Tools.tar
wget --quiet http://www.nordicsemi.com/eng/nordic/download_resource/52615/10/16598466 -O nRF5-Tools.tar
mkdir tools
cp nRF5-Tools.tar tools/
cd tools
tar xf nRF5-Tools.tar &> /dev/null
rm nRF5-Tools.tar
cd -

# Configure SD makefile to point at our copy of ARM toolchain
sed -i 's|GNU_INSTALL_ROOT.*|GNU_INSTALL_ROOT := /home/vagrant/gcc-arm-none-eabi-5_4-2016q2|' sdk/components/toolchain/gcc/Makefile.posix
sed -i 's|GNU_VERSION.*|GNU_VERSION := 5.4.0|' sdk/components/toolchain/gcc/Makefile.posix
sed -i 's|GNU_PREFIX.*|GNU_PREFIX := arm-none-eabi|' sdk/components/toolchain/gcc/Makefile.posix

# Set up nano board header
cp /vagrant_data/custom_board.h sdk/examples/bsp/
sed -i '42i#define NRF_CLOCK_LFCLKSRC {.source = NRF_CLOCK_LF_SRC_XTAL, .rc_ctiv = 0, .rc_temp_ctiv = 0, .xtal_accuracy = NRF_CLOCK_LF_XTAL_ACCURACY_20_PPM}' sdk/examples/bsp/custom_board.h

# Configure build to use our custom board header
sed -i 's/BOARD_PCA10028/BOARD_CUSTOM/' sdk/examples/ble_peripheral/ble_app_hrs/pca10028/s130/armgcc/Makefile

# Adjust linker script for nano's 16kB RAM
sed -i 's/0x5f80/0x2000/' sdk/examples/ble_peripheral/ble_app_hrs/pca10028/s130/armgcc/ble_app_hrs_gcc_nrf51.ld

# Run a test build
cd sdk/examples/ble_peripheral/ble_app_hrs/pca10028/s130/armgcc
make clean && make || exit 1

# Assemble the binary file with the soft stack
~/tools/mergehex/mergehex --merge ~/sdk/components/softdevice/s130/hex/s130_nrf51_2.0.0_softdevice.hex ~/sdk/examples/ble_peripheral/ble_app_hrs/pca10028/s130/armgcc/_build/nrf51422_xxac_s130.hex --output ~/hrs.hex || exit 1

# Copy the binary file to shared folder so you can drag drop onto the MK20's folder (if on windows)
cp -f ~/hrs.hex /vagrant_data
