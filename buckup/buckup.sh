#!/bin/bash

show_help() {
  
  echo "Description: Bash tool for buckup directory"
  echo "Usage:"
  echo "  -b  buckup dirs"
  echo "  -h  Show the help ..."
  echo "  -r  recover"
  echo "Examples: 
 \$ buckup.sh -b <source dir> <buckup_dir> 
 \$ buckup.sh -r <zrchive full path>
 "
  exit 0
}



check_days_passed() {
    local given_date_seconds=$1
    local current_date_seconds=$(date +%s)

    local seven_days_seconds=$((7 * 24 * 60 * 60))

    if [ "$((current_date_seconds - given_date_seconds))" -ge "$seven_days_seconds" ]; then
        return 1 # True
    else
        return 0 # False
    fi
}

full_bak() {
    local timestemp=$(date "+%Y%m%d")
    find "$1"/ ! -name 'cleanup.log' -type f -mmin +1440 -exec rm {} \; -exec echo "Deleted file: {} ${timestemp}" \; >> "$1"/cleanup.log
    tar -cvpzf "$1"/full_${timestemp}.tar.gz --listed-incremental="$1"/backup.snar "$2"/
}

inc_bak() {
    local timestemp=$(date "+%Y%m%d")
    tar -cvpzf "$1"/full_${timestemp}.tar.gz --listed-incremental="$1"/backup.snar "$2"/
}


backup() {
    bak_dir=$2
    source_dir=$1
    full_bak_time=$(date +%s)
    while true; do
        if check_days_passed "$full_bak_time"; then
            echo "7 days have passed. Perform backup."
            full_bak "$bak_dir" "$source_dir"
            #echo "created full backup" | mail -s "Full Backup" test@mail.com
            full_bak_time=$(date +%s)
        else
            echo "Less than 7 days have passed. Performing incremental backup."
            inc_bak "$bak_dir" "$source_dir"
            #echo "created incremental backup" | mail -s "Incremental Backup" test@mail.com
        fi

        sleep 86400 
    done
}

recover() {
    for file in "$1"/*.tar.gz; do
        echo "Extracting $file..."
        tar -xvpzf "$file" -C / --numeric-owner
    done
}


case "$1" in
    -r)
        if [ $# -ne 2 ]; then
            echo "Usage: bak.sh -r <zrchive full path>"
            exit 1
        fi
        recover $2
        ;;
    -b)
        if [ $# -ne 3 ]; then
            echo "Usage: bak.sh -b <source dir> <buckup_dir>"
            exit 1
        fi
        backup $2 $3
        ;;
    -h)
        show_help
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
esac