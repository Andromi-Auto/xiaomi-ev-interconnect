#!/system/bin/sh
# Runs after boot. Android loads saved persist.* values after post-fs-data, which can turn these
# off again, so they are set once more here; the read-only (ro.*) ones in post-fs-data cannot change.

# Wait until the Android framework and Package Manager are fully ready
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 3
done

# Short delay to ensure PackageManagerService has finished loading permissions
sleep 3

resetprop persist.sys.crossover.enable true
resetprop persist.sys.mi_connect.enable true

# Battery (Doze) whitelist and background execution exemptions
dumpsys deviceidle whitelist +com.xiaomi.mis
cmd appops set com.xiaomi.mis START_FOREGROUND allow
cmd appops set com.xiaomi.mis RUN_IN_BACKGROUND allow
cmd appops set com.xiaomi.mis RUN_ANY_IN_BACKGROUND allow

# Grant runtime permissions in every user profile (user 0, work profile, second space...)
for user in $(pm list users | grep -o 'UserInfo{[0-9]*' | cut -d '{' -f 2); do
    pm grant --user "$user" com.xiaomi.mis android.permission.BLUETOOTH_CONNECT 2>/dev/null
    pm grant --user "$user" com.xiaomi.mis android.permission.BLUETOOTH_SCAN 2>/dev/null
    pm grant --user "$user" com.xiaomi.mis android.permission.BLUETOOTH_ADVERTISE 2>/dev/null
    pm grant --user "$user" com.xiaomi.mis android.permission.ACCESS_FINE_LOCATION 2>/dev/null
    pm grant --user "$user" com.xiaomi.mis android.permission.ACCESS_COARSE_LOCATION 2>/dev/null
    pm grant --user "$user" com.xiaomi.mis android.permission.POST_NOTIFICATIONS 2>/dev/null
done

# Wi-Fi country CN: Interconnectivity's Wi-Fi P2P only works on the Chinese regulatory domain,
# whatever the ROM. Android's override beats the SIM's country and is kept in memory only, so it
# is set on every boot. The Wi-Fi service can answer a little after boot, hence the retries.
wifi_cn() { cmd wifi get-country-code 2>/dev/null | grep -q '= CN'; }
i=0
until wifi_cn || [ $i -ge 30 ]; do
    cmd wifi force-country-code enabled CN >/dev/null 2>&1
    i=$((i + 1))
    sleep 2
done

# Re-apply if anything (a Wi-Fi service restart) clears it; one cheap check a minute.
while true; do
    sleep 60
    wifi_cn || cmd wifi force-country-code enabled CN >/dev/null 2>&1
done &
