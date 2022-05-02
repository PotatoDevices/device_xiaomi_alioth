#
# Copyright (C) 2022 The Potato Open Sauce Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Shipping API
PRODUCT_SHIPPING_API_LEVEL := 30

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xhdpi

# Platform
PRODUCT_BOARD_PLATFORM := kona
PRODUCT_USES_QCOM_HARDWARE := true

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/xiaomi/alioth/alioth-vendor.mk)
