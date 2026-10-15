#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#
# ==============================================================
#  device.mk untuk SM-M127F (m12) — DIISI ULANG
#  Aslinya cuma berisi "LOCAL_PATH := device/samsung/m12"
#  (kosong) -> build gagal / TWRP tidak berguna.
# ==============================================================

LOCAL_PATH := device/samsung/m12

# ---------------------------------------------------------------
#  A/B vs A-only
#  m12 = A-only (tidak ada slot A/B)
# ---------------------------------------------------------------
AB_OTA_UPDATER := false

# ---------------------------------------------------------------
#  Dynamic partitions (super)
# ---------------------------------------------------------------
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := true

# ---------------------------------------------------------------
#  API level
# ---------------------------------------------------------------
PRODUCT_TARGET_VNDK_VERSION := 33
PRODUCT_SHIPPING_API_LEVEL := 33

# ---------------------------------------------------------------
#  VINTF / manifest
# ---------------------------------------------------------------
PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := false

# ---------------------------------------------------------------
#  Fitur khas Samsung
# ---------------------------------------------------------------
PRODUCT_CHARACTERISTICS := phone
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# ---------------------------------------------------------------
#  Salin file dari device tree ke image
# ---------------------------------------------------------------
# recovery.fstab  -> dipakai TWRP untuk tahu daftar partisi
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/recovery.fstab

# ---------------------------------------------------------------
#  Properti khas recovery
# ---------------------------------------------------------------
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware=exynos850 \
    ro.board.platform=exynos850 \
    ro.boot.hardware=exynos850 \
    ro.crypto.state=unencrypted \
    ro.crypto.type=none \
    persist.sys.usb.config=mtp,adb \
    ro.adb.secure=0 \
    ro.secure=0 \
    ro.debuggable=1

# ---------------------------------------------------------------
#  PENTING: jangan set ro.crypto.* ke encrypted
#  TWRP perlu bisa akses /data sebelum enkripsi.
#  m12 pakai FBE (file-based encryption).
# ---------------------------------------------------------------
PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.dm_default_key.options_format.version=2 \
    ro.crypto.volume.filenames_mode=aes-256-cts

# ---------------------------------------------------------------
#  Bahasa
# ---------------------------------------------------------------
PRODUCT_LOCALES := en_US,id_ID,in_ID

# ---------------------------------------------------------------
#  Kernel modules (kalau ada)
# ---------------------------------------------------------------
# (tidak dipakai — m12 pakai kernel monolithic)

# ---------------------------------------------------------------
#  Inherit TWRP common
# ---------------------------------------------------------------
# omni_m12.mk sudah mewarisi vendor/omni/config/common.mk
# Jadi tidak perlu diulang di sini.
