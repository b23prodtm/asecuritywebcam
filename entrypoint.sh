#!/usr/bin/env bash
if [ -z "${SHM_SIZE}" ]; then
    echo "Calculating the SHM_SIZE value as 30% of Total Memory"
    SHM_SIZE=$(free -m | awk '/^Mem/ {printf "%.0fG",0.3*$2/1024}')
fi
printf "Remounting shm with size %s ..." "${SHM_SIZE}"
mount -o remount,rw,exec,size="${SHM_SIZE}" /dev/shm
printf "Remounting shm with size %s ...DONE" "${SHM_SIZE}"
/config_mtx.sh "$MTX_PATH"
/mediamtx