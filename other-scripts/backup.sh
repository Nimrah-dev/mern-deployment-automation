#!/bin/bash
#
<< readme
this is a script for backup with 5 day rotation
usage: 
./backup.sh <path to source> <path to backup folder>
readme

set -euo pipefail

display_usage() {
	echo "usage:
	./backup.sh <path to source> <path to backup folder>"
}


if [ $# -ne 2 ]; then
	display_usage
	exit 1
fi

source_dir=$1
backup_dir=$2
timestamp=$( date '+%Y-%m-%d-%H-%M-%S')

if [ ! -d "$source_dir" ]; then
	echo "Source folder not found"
	exit 1
fi

create_backup() {
	zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" > /dev/null
	if [ $? -eq 0 ]; then
	echo " backup generated successfully for  $timestamp"
else
	echo "backup failed"
	fi
}


perform_rotation() {
	backups=($(ls -t "${backup_dir}/backup_"*.zip 2>/dev/null))


if [ "${#backups[@]}" -gt 5 ]; then
	echo " performing rotation"
	backup_to_remove=("${backups[@]:5}")
	echo " ${backup_to_remove[@]} "

	for backup in "${backup_to_remove[@]}"
	do
		rm -f "${backup}"
	done
fi
}

create_backup
perform_rotation
