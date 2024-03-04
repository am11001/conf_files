process_info=$(ps axo pid,user,cmd,rsz --sort=-rsz | head -n 16 | tail -n 15)


human_readable() {
    awk '{
        hum[1024**4]="TB"; hum[1024**3]="GB"; hum[1024**2]="MB"; hum[1024]="KB";
        for (x=1024**4; x>=1024; x/=1024){
            if ($1>=x) {
                printf "%.1f %s\n",$1/x,hum[x];break
            }
        }
    }'
}

echo "PID USER COMMAND RESIDENT_MEMORY"

while IFS= read -r line; do
    pid=$(echo "$line" | awk '{print $1}')
    user=$(echo "$line" | awk '{print $2}')
    command=$(echo "$line" | awk '{$1=$2=""; print $0}')
    memory=$(echo "$line" | awk '{print $NF}')
    res_memory=$(echo "$memory" | human_readable)
    echo "$pid $user $command $res_memory"
done <<< "$process_info"