#!/system/bin/sh
# Runs early in boot, before apps start. Read-only (ro.*) properties set here stay set until the
# next reboot, so they are set only here. File permissions are set by KernelSU/Magisk at install.

# Region: the car connection service only runs on the Chinese region
resetprop ro.miui.region CN
resetprop ro.miui.customized.region CN
resetprop ro.boot.hwc CN

# Car connection and interconnectivity features
resetprop ro.miui.support_carlink 1
resetprop ro.miui.support_milink 1
resetprop ro.miui.support_continuity 1
resetprop persist.sys.crossover.enable true
resetprop persist.sys.mi_connect.enable true
