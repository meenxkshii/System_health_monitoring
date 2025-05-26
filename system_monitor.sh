#!/bin/bash
#set -x

#Configurations
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90

#Functions to get the metrics
get_cpu_usage()
{
     top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" |  awk '{print 100 - $1}' | cut -d. -f1 
}

get_mem_usage() 
{
    free | grep Mem | awk '{print ($3/$2) * 100.0}' | cut -d. -f1 # Get integer part only
}

get_disk_usage() 
{
    df -h / | awk 'NR==2 {print $5}' | sed 's/%//g'
}

#Main Logic for Monitoring 
echo "System Health Check!"
ALERT_TRIGGERED=false
CURRENT_CPU=$(get_cpu_usage)
echo "CPU Usage is ${CURRENT_CPU}%"
if((CURRENT_CPU > CPU_THRESHOLD)); then
    echo "ALERT: CPU usage (${CURRENT_CPU}%) is above threshold (${CPU_THRESHOLD}%)!"
    ALERT_TRIGGERED=true
fi

CURRENT_MEM=$(get_mem_usage)
echo "Memory Usage is ${CURRENT_MEM}%"
if (( CURRENT_MEM > MEM_THRESHOLD )); then
    echo "ALERT: Memory usage (${CURRENT_MEM}%) is above threshold (${MEM_THRESHOLD}%)!"
    ALERT_TRIGGERED=true
fi

CURRENT_DISK=$(get_disk_usage)
echo "Disk Usage is ${CURRENT_DISK}%"
if (( CURRENT_DISK > DISK_THRESHOLD )); then
    echo "ALERT: Disk usage (${CURRENT_DISK}%) is above threshold (${DISK_THRESHOLD}%)!"
    ALERT_TRIGGERED=true
fi

if [ "$ALERT_TRIGGERED" = true ]; then
    echo "Action required!"
else
    echo "System is normal :)"
fi

echo "End of System Check"


