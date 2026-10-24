# Changelog

## v4

- Sets the **Wi-Fi country to CN** on every boot (`cmd wifi force-country-code enabled CN`), which
  Interconnectivity's Wi-Fi P2P connection to the car needs on every ROM. The LSPosed/Vector
  "WiFi Country Code" module is no longer needed: disable it.
- Checks once a minute that the Wi-Fi country is still CN and sets it again if not.

## v3

- Read-only properties are set once in `post-fs-data.sh`; `service.sh` no longer repeats them (they cannot change after early boot). The `persist.sys.*` properties are still set again after boot, because Android loads saved values after `post-fs-data`.
- File permissions are no longer reset on every boot: KernelSU/Magisk already set them at install.
- The privileged permission list now matches what MIS 3.0.4 actually requests (it was missing most of them, which stops a ROM that enforces the list from booting) and drops entries MIS does not request.
- `updateJson`: KernelSU and Magisk show when a new version is available.

## v2

- First published version.
