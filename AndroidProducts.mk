#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#
# ==============================================================
#  AndroidProducts.mk — DIPERBAIKI untuk TWRP 14 (twrp-14.1)
#
#  MASALAH SEBELUMNYA:
#     "Invalid lunch combo: omni_m12-eng"
#     TWRP 12.1+ tidak lagi memakai prefix "omni_".
#     Produk harus bernama "twrp_<device>".
#
#  vendorsetup.sh sudah OBSOLETE di TWRP 14
#  ("add_lunch_combo is obsolete"), jadi pendaftaran product
#  HANYA lewat file ini.
# ==============================================================

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/twrp_m12.mk

COMMON_LUNCH_CHOICES := \
    twrp_m12-eng \
    twrp_m12-userdebug \
    twrp_m12-user
