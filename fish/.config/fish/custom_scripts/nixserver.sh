#!/usr/bin/env bash

if [[ "$1" = "-u" ]]; then
    sudo umount /run/media/nixos_storage/
elif [[ "$1" = "-m" ]]; then
    sudo mount -t cifs //192.168.1.191/public_storage /run/media/nixos_storage -o guest,vers=3.0,uid=1000,gid=1000,file_mode=0777,dir_mode=0777
elif [[ "$1" = "-s" ]]; then
    ssh x12@192.168.1.191
fi
