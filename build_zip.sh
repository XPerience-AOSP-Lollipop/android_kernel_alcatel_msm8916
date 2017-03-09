#
# Copyright � 2016,  Sultan Qasim Khan <sultanqasim@gmail.com>
# Copyright � 2016,  Zeeshan Hussain <zeeshanhussain12@gmail.com>
# Copyright � 2016,  Varun Chitre  <varun.chitre15@gmail.com>
# Copyright � 2016,  Aman Kumar  <firelord.xda@gmail.com>
# Copyright � 2016,  Kartik Bhalla <kartikbhalla12@gmail.com> 

# Custom build script
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it
#

#!/bin/bash
KERNEL_DIR=~/android/kernel/lenovo/p1a42
KERN_IMG=$KERNEL_DIR/arch/arm64/boot/Image
DTBTOOL=$KERNEL_DIR/tools/dtbToolCM
export ARCH=arm64
export CROSS_COMPILE=~/android/kernel/toolchain/google-64-4.9/bin/aarch64-linux-android-
rm -f arch/arm/boot/dts/*.dtb
rm -f arch/arm64/boot/dt.img
rm -f flash_zip/boot.img
make mrproper
make p1a42_defconfig
make -j10
make -j10 dtbs
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
rm -rf kernel_install
mkdir -p kernel_install
make -j4 modules_install INSTALL_MOD_PATH=kernel_install INSTALL_MOD_STRIP=1
mkdir -p flash_zip/system/lib/modules/
find kernel_install/ -name '*.ko' -type f -exec cp '{}' flash_zip/system/lib/modules/ \;
cp arch/arm64/boot/Image flash_zip/tools/
cp arch/arm64/boot/dt.img flash_zip/tools/
mkdir -p ~/android/kernel/upload/p1a42/
rm -f ~/android/kernel/upload/p1a42/*
cd flash_zip
zip -r ../arch/arm64/boot/kernel.zip ./
today=$(date +"-%d%m%Y")
mv ~/android/kernel/lenovo/p1a42/arch/arm64/boot/kernel.zip ~/android/kernel/upload/p1a42/Kernel$today.zip
