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
