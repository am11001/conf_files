#!/bin/bash 

case "$1" in
    -j) # using journalctl
        output=$(journalctl -u ssh --since "1 hour ago")
        ;;
    -f) # using input file
        file=$2
        output=$(cat "$file")
        ;;
    *)
        echo "Please specify the log file or journalctl"
        exit 1
        ;;
esac  

# echo "$output" | grep -E -o '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*' | sort | uniq -c

text=$(echo "$output" | grep -e "Invalid user" -e "Authentication failure")

awk '{
    if ($5=="Invalid"){
        print  $9 
        }
    else{
        print $12
    }     
}' <<< $text | sort | uniq -c| while IFS= read -r line; do 
    echo "test"
    count=$(echo $line | awk '{print $1}')
    if [ $count -gt 10 ];then
        ip-address=$(echo $line | awk '{print $2}')
        iptables -A INPUT -s ip-address -j DROP
    fi
done

