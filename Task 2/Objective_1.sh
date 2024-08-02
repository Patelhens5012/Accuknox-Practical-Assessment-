#!/bin/bash

CPU_THRESHOLD=80

MEMORY_THRESHOLD=80

DISK_THRESHOLD=80

PROCESS_THRESHOLD=300

LOG_FILE="system_health.log"

check_cpu_usage() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        echo "$(date '+%Y-%m-%d  %H:%M:%S') - High CPU usage detected: ${cpu_usage}%" >> "$LOG_FILE"
    fi

}

check_memory_usage() {
    
    memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "$(date '+%Y-%m-%d  %H:%M:%S') - High memory usage detected: ${memory_usage}%" >> "$LOG_FILE"
    fi

}

check_disk_usage() {
    
    disk_usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    if (( disk_usage > DISK_THRESHOLD )); then
        echo "$(date '+%Y-%m-%d  %H:%M:%S') - Low disk space detected: ${disk_usage}% used" >> "$LOG_FILE"
    fi

}

check_running_processes() {
    
    process_count=$(ps aux | wc -l)
    if (( process_count > PROCESS_THRESHOLD )); then
        echo "$(date '+%Y-%m-%d  %H:%M:%S') - High number of running processes detected: ${process_count}" >> "$LOG_FILE"
    fi

}

monitor_system() {

    check_cpu_usage

    check_memory_usage

    check_disk_usage

    check_running_processes

}

monitor_system
