#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#
# ==============================================================
#  BoardConfig.mk untuk SM-M127F (m12)
#
#  DIUBAH dari versi repo, dengan 4 perbaikan:
#   1. Kernel prebuilt diganti kernel STOK DWC4 (dari HP Master)
#   2. BOARD_BOOTIMAGE/ RECOVERYIMAGE PARTITION_SIZE dibetulkan
#      (55574528 -> 46137344, sesuai partisi nyata di HP)
#   3. AVB: recovery pakai flags 3 (verifikasi DIMATIKAN untuk
#      recovery) supaya TWRP bisa jalan tanpa ditolak
#   4. Anti-rollback hack ditinjau
# ==============================================================

DEVICE_PATH := device/samsung/m12

# ---------------------------------------------------------------
#  For building with minimal manifest
# ---------------------------------------------------------------
ALLOW_MISSING_DEPENDENCIES := true

# ---------------------------------------------------------------
#  Architecture
#  exynos850 = ARM64 + 32-bit companion (Cortex-A55)
# ---------------------------------------------------------------
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a55          # <-- diperbaiki (0xd05)

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55      # <-- diperbaiki

# ---------------------------------------------------------------
#  APEX
# ---------------------------------------------------------------
DEXPREOPT_GENERATE_APEX_IMAGE := true

# ---------------------------------------------------------------
#  Bootloader / platform
# ---------------------------------------------------------------
TARGET_BOOTLOADER_BOARD_NAME := exynos850
TARGET_NO_BOOTLOADER := true
TARGET_BOARD_PLATFORM := exynos850                 # <-- diperbaiki
                                                   # (aslinya universal3830,
                                                   #  itu SoC lain/Exynos 1280)

# ---------------------------------------------------------------
#  Display
# ---------------------------------------------------------------
TARGET_SCREEN_DENSITY := 300
TARGET_SCREEN_HEIGHT := 1600
TARGET_SCREEN_WIDTH := 720

# ---------------------------------------------------------------
#  Kernel — header v2, page 2048 (cocok dgn boot.img HP)
# ---------------------------------------------------------------
BOARD_BOOTIMG_HEADER_VERSION := 2
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_CMDLINE := androidboot.hardware=exynos850 androidboot.selinux=enforce loop.max_part=7
BOARD_KERNEL_PAGESIZE := 2048
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_SEPARATED_DTBO := true
TARGET_KERNEL_CONFIG := exynos850-m12nsxx_defconfig   # <-- diperbaiki
TARGET_KERNEL_SOURCE := kernel/samsung/m12

# ---------------------------------------------------------------
#  Kernel — PREBUILT (tidak build kernel, pakai kernel jadi)
#  >>> INI KUNCI KEAMANANNYA <<<
#  kernel di prebuilt/kernel = kernel STOK SAMSUNG DWC4
#  (4.19.111-26004678 dpi@SWDK3905), 0 kata kernelsu/magisk.
#  Inilah kernel yang HP TERIMA saat boot normal.
# ---------------------------------------------------------------
TARGET_FORCE_PREBUILT_KERNEL := true
ifeq ($(TARGET_FORCE_PREBUILT_KERNEL),true)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_INCLUDE_DTB_IN_BOOTIMG :=
BOARD_KERNEL_SEPARATED_DTBO :=
endif

# ---------------------------------------------------------------
#  Partitions
#  >>> UKURAN DIPERBAIKI <<<
#  Repo asli: 55574528 (55,5 MB)
#  Kenyataan : 46137344 (44,0 MB) = ukuran boot.img stok HP
# ---------------------------------------------------------------
BOARD_FLASH_BLOCK_SIZE := 131072                 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 46137344
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 46137344
BOARD_HAS_LARGE_FILESYSTEM := true

BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs    # <-- diperbaiki
                                                # (HP pakai f2fs utk /data)
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# Dynamic partitions (super)
BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_SUPER_PARTITION_GROUPS := samsung_dynamic_partitions
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system system_ext vendor product odm vendor_dlkm system_dlkm
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_SIZE := 9122611200

# ---------------------------------------------------------------
#  Recovery
# ---------------------------------------------------------------
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS := efs

# ---------------------------------------------------------------
#  Verified Boot / AVB
#
#  >>> PENTING <<<
#  Recovery TWRP HARUS punya vbmeta flags=3 (verifikasi
#  DIMATIKAN). Kalau tidak, bootloader akan menolak TWRP
#  karena ramdisk-nya beda dari ramdisk stok.
#
#  TAPI: vbmeta yang dipakai Android TETAP flags=0 (stok).
#  Jangan flash vbmeta ini ke partisi vbmeta utama!
#
#  TWRP di sini ditaruh di partisi RECOVERY. Partisi
#  recovery TIDAK diperiksa oleh AVB chain saat boot normal,
#  jadi aman.
# ---------------------------------------------------------------
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# ---------------------------------------------------------------
#  Anti-rollback
#  >>> DIPERBAIKI <<<
#  Repo asli menyetel PLATFORM_SECURITY_PATCH=2099-12-31 dan
#  VENDOR_SECURITY_PATCH=2099-12-31 (doa "hack: prevent anti
#  rollback"). Itu nilai palsu yang bisa bikin masalah
#  konsistensi. Kita pakai nilai asli HP (2023-03-01).
# ---------------------------------------------------------------
PLATFORM_SECURITY_PATCH := 2023-03-01
VENDOR_SECURITY_PATCH := 2023-03-01
PLATFORM_VERSION := 13

# ---------------------------------------------------------------
#  SELinux — TWRP butuh permissive supaya bisa operasi partisi
# ---------------------------------------------------------------
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy

# ---------------------------------------------------------------
#  TWRP
# ---------------------------------------------------------------
TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_USE_TOOLBOX := true
TW_HAS_DOWNLOAD_MODE := true

# Wajib untuk Samsung
TW_DEVICE_VERSION := m12-Kuyukbot1
TW_INCLUDE_CRYPTO := false
TW_INCLUDE_FBE := false
TW_NO_SCREEN_BLANK := true
TW_ROTATION := 0

# Jangan minta password/key saat masuk (m12 FBE tidak didukung TWRP)
TW_CRYPTO_FS_TYPE := f2fs
TW_CRYPTO_REAL_BLKDEV := /dev/block/platform/13540000.dwmmc0/by-name/userdata

# ---------------------------------------------------------------
#  USB
# ---------------------------------------------------------------
TW_EXCLUDE_DEFAULT_USB_INIT := true
