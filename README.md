# Xiaomi EV Interconnect

A KernelSU module that adds **Xiaomi Interconnectivity for the car** (the Xiaomi EV car connection service, `com.xiaomi.mis`) to HyperOS **Global and EEA (EU) ROMs**, which do not have it. With it, the phone connects to a Xiaomi EV and can show phone apps such as [Andromi Auto](https://andromi-auto.github.io) on the car screen.

Part of the [Andromi Auto](https://andromi-auto.github.io) project, but it works on its own.

## Requirements

- A Xiaomi phone on **HyperOS** with a Global or EEA ROM
- **Unlocked bootloader** and **KernelSU** (Magisk also works)

## Install

1. Download **`xiaomi-ev-interconnect-<version>.zip`** from the [latest release](https://github.com/Andromi-Auto/xiaomi-ev-interconnect/releases/latest).
2. Open **KernelSU** → **Module** → **Install**, and choose the zip.
3. **Reboot** the phone.

Later versions show up as an update in KernelSU's module list.

## What it does

- Installs **MIS** (`com.xiaomi.mis`, the Xiaomi car connection service) as a privileged system app, with its permission list and feature flags.
- Sets the properties that turn on car connection and interconnectivity (`ro.miui.support_carlink`, `ro.miui.support_milink`, `ro.miui.support_continuity`, `persist.sys.crossover.enable`, `persist.sys.mi_connect.enable`).
- **Sets the Wi-Fi country to CN** on every boot (`cmd wifi force-country-code enabled CN`), and
  checks once a minute that it stays CN. Interconnectivity connects to the car over Wi-Fi P2P,
  which only works on the Chinese Wi-Fi region, on every ROM. This replaces the LSPosed/Vector
  "WiFi Country Code" module: if you used it, disable it.
- **Sets the phone's region to CN** (`ro.miui.region`, `ro.miui.customized.region`, `ro.boot.hwc`): the car connection service only runs on the Chinese region.
- After boot: keeps MIS out of battery optimisation, allows it to run in the background, and grants its Bluetooth, location and notification permissions in every user profile.

Because the region and Wi-Fi country are CN, other Xiaomi apps that check the region may behave as on a Chinese ROM (for example the Themes store or region-specific features). Nothing changes on disk: uninstalling the module and rebooting restores the original region.

## Uninstall

KernelSU → **Module** → remove **Xiaomi EV Interconnect**, then reboot.

## Files

| File | What it is |
| --- | --- |
| `module.prop` | Module name, version and update link |
| `post-fs-data.sh` | Runs early in boot: sets the properties |
| `service.sh` | Runs after boot: battery and background exemptions, permissions, Wi-Fi country CN |
| `system/` | The apps and configuration added to `/product` |
| `META-INF/` | Standard installer for KernelSU/Magisk |
| `update.json` | Read by KernelSU/Magisk to offer updates |

## Releasing a new version

Change `version` and `versionCode` in `module.prop`, the same values in `update.json`, and add a
section to `CHANGELOG.md`. On push to `main`, GitHub Actions builds `xiaomi-ev-interconnect-<version>.zip` and
publishes the release.

## Disclaimer

Use at your own risk; a system module can stop a phone from booting, so know how to remove a
module from recovery or KernelSU's safe mode first. The apps in `system/` belong to Xiaomi. Not
affiliated with Xiaomi.
