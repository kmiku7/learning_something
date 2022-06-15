#!/usr/bin/env bash
# grap-system-info.sh
# We cann't use `sleep` to block the script to wait the external termination signal,
# since after we use `trap` command, the sleep cann't receive any signal,
# either the `display_info` function.

PLACEHOLDER_FILE=`mktemp -ut system-info-collector-pipe.XXXXXXXX`
mkfifo "${PLACEHOLDER_FILE}"

function display_info()
{
    echo "===== Start Grab System Info ====="
    echo "===== Show Kernel Info ====="
    dmesg -T || true
    # dmesg -T | tail -n 400 || true
    echo "===== Show Disk Info ====="
    df -lh || true
    echo "===== Show Memory Info ====="
    free -g || true
    echo "===== End Grab System Info ====="
    rm -f "${PLACEHOLDER_FILE}" || true
    exit 0
}
trap display_info SIGTERM SIGINT

echo "Wait for termination signal."
echo $$
read <"${PLACEHOLDER_FILE}"
