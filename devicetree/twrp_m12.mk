#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# ==============================================================
#  twrp_m12.mk — nama produk untuk TWRP 14 (twrp-14.1)
#
#  PENTING: TWRP versi 12.1 ke atas memakai prefix "twrp_",
#  BUKAN "omni_". Kalau tetap pakai omni_m12, lunch akan bilang:
#     "Invalid lunch combo: omni_m12-eng"
# ==============================================================

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit TWRP common config
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from m12 device
$(call inherit-product, device/samsung/m12/device.mk)

PRODUCT_DEVICE := m12
PRODUCT_NAME := twrp_m12
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-M127F
PRODUCT_MANUFACTURER := samsung

PRODUCT_GMS_CLIENTID_BASE := android-samsung-ss

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="m12nsxx-user 13 TP1A.220624.014 M127FXXU4DWC4 release-keys"

BUILD_FINGERPRINT := samsung/m12nsxx/m12:13/TP1A.220624.014/M127FXXU4DWC4:user/release-keys
