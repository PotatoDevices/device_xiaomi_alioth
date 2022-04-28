#
# Copyright (C) 2021 Snuggy Wuggy Research and Development Center 
#                    and The hentaiOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_PATH := device/xiaomi/alioth

include build/make/target/board/BoardConfigMainlineCommon.mk
include build/make/target/board/BoardConfigPixelCommon.mk

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a55
TARGET_CPU_VARIANT_RUNTIME := cortex-a55

ifeq (,$(filter %_64,$(TARGET_PRODUCT)))
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a53
endif

BUILD_BROKEN_ENFORCE_SYSPROP_OWNER := true
BUILD_BROKEN_VINTF_PRODUCT_COPY_FILES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Assert
TARGET_OTA_ASSERT_DEVICE := alioth

# Board Info
TARGET_BOARD_INFO_FILE := device/xiaomi/alioth/board-info.txt

# Kernel
BOARD_KERNEL_CMDLINE += console=ttyMSM0,115200n8 androidboot.console=ttyMSM0 printk.devkmsg=on
BOARD_KERNEL_CMDLINE += androidboot.hardware=gourami androidboot.hardware.platform=sm8250
BOARD_KERNEL_CMDLINE += msm_rtb.filter=0x237
BOARD_KERNEL_CMDLINE += ehci-hcd.park=3
BOARD_KERNEL_CMDLINE += service_locator.enable=1
BOARD_KERNEL_CMDLINE += androidboot.memcg=1 cgroup.memory=nokmem
BOARD_KERNEL_CMDLINE += lpm_levels.sleep_disabled=1
BOARD_KERNEL_CMDLINE += usbcore.autosuspend=7
BOARD_KERNEL_CMDLINE += androidboot.usbcontroller=a600000.dwc3 swiotlb=2048
BOARD_KERNEL_CMDLINE += loop.max_part=7

BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_RAMDISK_OFFSET     := 0x01000000

BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_BOOT_HEADER_VERSION := 3
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

TARGET_KERNEL_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME := Image
TARGET_PREBUILT_KERNEL := device/xiaomi/alioth-kernel/Image

# DTBO partition definitions
BOARD_PREBUILT_DTBOIMAGE := device/xiaomi/$(TARGET_BOOTLOADER_BOARD_NAME)-kernel/dtbo.img
BOARD_DTBOIMG_PARTITION_SIZE := 33554432

TARGET_NO_KERNEL := false
BOARD_USES_METADATA_PARTITION := true

# Screen Density
TARGET_SCREEN_DENSITY := 440

# GKI
BOARD_USES_GENERIC_KERNEL_IMAGE := true

# A/B Paritioning
ifneq ($(PRODUCT_BUILD_SYSTEM_IMAGE),false)
AB_OTA_PARTITIONS += system
AB_OTA_PARTITIONS += vbmeta_system
endif
#ifneq ($(BOARD_PREBUILT_VENDORIMAGE),false) // We assume vendor always exists
AB_OTA_PARTITIONS += vendor
# endif
ifneq ($(PRODUCT_BUILD_PRODUCT_IMAGE),false)
AB_OTA_PARTITIONS += product
endif
ifneq ($(PRODUCT_BUILD_SYSTEM_EXT_IMAGE),false)
AB_OTA_PARTITIONS += system_ext
endif
ifneq ($(PRODUCT_BUILD_BOOT_IMAGE),false)
AB_OTA_PARTITIONS += boot
endif
ifneq ($(PRODUCT_BUILD_VENDOR_BOOT_IMAGE),false)
AB_OTA_PARTITIONS += vendor_boot
AB_OTA_PARTITIONS += dtbo
endif
ifneq ($(PRODUCT_BUILD_VBMETA_IMAGE),false)
AB_OTA_PARTITIONS += vbmeta
endif

# A/B recovery support
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true
ifneq ($(PRODUCT_BUILD_VENDOR_BOOT_IMAGE),false)
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
endif
TARGET_NO_RECOVERY := true

# Sepolicy
TARGET_SEPOLICY_DIR := kona
include device/qcom/sepolicy_vndr/SEPolicy.mk
PRODUCT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
BOARD_SEPOLICY_M4DEFS += \
    public_vendor_default_prop=vendor_public_vendor_default_prop \
    sensors_prop=vendor_sensors_prop

# Recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 165
TARGET_RECOVERY_WIPE := $(DEVICE_PATH)/recovery.wipe
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/fstab.hardware
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# Enable chain partition for system.
BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

# vendor.img
BOARD_PREBUILT_VENDORIMAGE := vendor/xiaomi/alioth-vendor/vendor.img
#BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

ifneq ($(WITH_GMS),true)
BOARD_PRODUCTIMAGE_EXTFS_INODE_COUNT := -1
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 536870912
BOARD_SYSTEM_EXTIMAGE_EXTFS_INODE_COUNT := -1
BOARD_SYSTEM_EXTIMAGE_PARTITION_RESERVED_SIZE := 536870912
BOARD_SYSTEMIMAGE_EXTFS_INODE_COUNT := -1
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 536870912
endif

# product.img
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4

# system_ext.img
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4

# userdata.img
TARGET_USERIMAGES_USE_F2FS := true
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10737418240
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

# boot.img
BOARD_BOOTIMAGE_PARTITION_SIZE := 134217728

# vendor_boot.img
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 0x06000000

# Allow LZ4 compression
BOARD_RAMDISK_USE_LZ4 := true
BOARD_FLASH_BLOCK_SIZE := 262144

# Disable AVB verity
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flag 3

# This should have been included in BoardConfigMainlineCommon.mk, but custom
# ROMs moved this flag to BoardConfigEmuCommon.mk to allow resulting system
# partitions to be mounted read/write. Such a world.
BOARD_EXT4_SHARE_DUP_BLOCKS := true

# dynamic partition
BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_SUPER_PARTITION_GROUPS := xiaomi_dynamic_partitions
BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    vendor \
    product \
    system_ext

#BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE is set to (5GB - 4MB)
BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := 5364514816

# Set error limit to BOARD_SUPER_PARTITON_SIZE - 500MB
BOARD_SUPER_PARTITION_ERROR_LIMIT := 8602517504

# DTB
BOARD_PREBUILT_DTBIMAGE_DIR := device/xiaomi/$(TARGET_BOOTLOADER_BOARD_NAME)-kernel

include device/xiaomi/alioth-firmware/BoardConfigVendor.mk
