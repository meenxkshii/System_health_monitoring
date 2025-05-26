#!/bin/bash
#set -x

#Configurations
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90

RECIPIENT_EMAIL="meenakshi.rajeev21@gmail.com" # <--- IMPORTANT: Change this to your email
SENDER_NAME="DevOps Monitor"
HOSTNAME=$BOLT-S # Get the hostname of the server

# Define paths for data files
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CURRENT_METRICS_FILE="${SCRIPT_DIR}/current_metrics.json"
HISTORY_METRICS_FILE="${SCRIPT_DIR}/metrics_history.csv"
MAX_HISTORY_LINES=100 # Keep only the last 100 entries in history


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

# Generate JSON for current metrics
JSON_OUTPUT="{
    \"timestamp\": \"${CURRENT_TIMESTAMP}\",
    \"hostname\": \"${HOSTNAME}\",
    \"cpu\": ${CURRENT_CPU},
    \"memory\": ${CURRENT_MEM},
    \"disk\": ${CURRENT_DISK},
    \"alert_triggered\": ${ALERT_TRIGGERED}
}"
echo "${JSON_OUTPUT}" > "${CURRENT_METRICS_FILE}"
echo "Generated current metrics to ${CURRENT_METRICS_FILE}"

# Append to CSV history
# Check if CSV header exists, if not, add it
if [ ! -f "${HISTORY_METRICS_FILE}" ] || [ "$(head -n 1 "${HISTORY_METRICS_FILE}")" != "Timestamp,Hostname,CPU,Memory,Disk" ]; then
    echo "Timestamp,Hostname,CPU,Memory,Disk" > "${HISTORY_METRICS_FILE}"
fi
echo "${CURRENT_TIMESTAMP},${HOSTNAME},${CURRENT_CPU},${CURRENT_MEM},${CURRENT_DISK}" >> "${HISTORY_METRICS_FILE}"
echo "Appended metrics to history file ${HISTORY_METRICS_FILE}"

# Keep only the last N lines in the history file (including header)
if [ $(wc -l < "${HISTORY_METRICS_FILE}") -gt $((MAX_HISTORY_LINES + 1)) ]; then
    (head -n 1 "${HISTORY_METRICS_FILE}" && tail -n "${MAX_HISTORY_LINES}" "${HISTORY_METRICS_FILE}") > "${HISTORY_METRICS_FILE}.tmp" && mv "${HISTORY_METRICS_FILE}.tmp" "${HISTORY_METRICS_FILE}"
    echo "Trimmed history file to last ${MAX_HISTORY_LINES} entries."
fi


# Send Email Alert if triggered
if [ "$ALERT_TRIGGERED" = true ]; then
    EMAIL_SUBJECT="CRITICAL: System Alert on ${HOSTNAME} - ${CURRENT_TIMESTAMP}"
    EMAIL_BODY="Dear Admin,\n\nThe following alerts were triggered on ${HOSTNAME}:\n\n${ALERT_MESSAGES}\n\nPlease investigate immediately.\n\n---\nSystem Health Report:\nCPU: ${CURRENT_CPU}%\nMemory: ${CURRENT_MEM}%\nDisk (/): ${CURRENT_DISK}%\n"
    echo -e "${EMAIL_BODY}" | mail -s "${EMAIL_SUBJECT}" -r "${SENDER_NAME} <noreply@${HOSTNAME}>" "${RECIPIENT_EMAIL}"
    echo "Email alert sent to ${RECIPIENT_EMAIL}"
else
    echo "--- All systems normal ---"
fi

echo "End of System Check"


