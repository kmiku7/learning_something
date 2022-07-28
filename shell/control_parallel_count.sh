#!/usr/bin/env bash
# Control the concurrent jobs count in background.

set -ex
ITEM_LIST="A B C"

CONCURRENT_CONDITION=$(mktemp -ut demo-concurrent-condition.XXXXXXXX.fifo)
mkfifo "${CONCURRENT_CONDITION}"
exec 5<>${CONCURRENT_CONDITION}
rm -rf ${CONCURRENT_CONDITION}

THREAD_NUM=2
for ((i = 1; i <= ${THREAD_NUM}; i++)); do
	echo >&5
done
for item in $ITEM_LIST; do
	read -u5
	{
		date
		echo $item
		sleep 5
		echo >&5
	} &
done
echo "start wait $(date)"
wait
echo "end wait $(date)"
exit $?
