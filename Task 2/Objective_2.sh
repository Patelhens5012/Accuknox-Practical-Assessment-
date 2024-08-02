#!/bin/bash

SRC_DIR="/var/lib/jenkins"

BACKUP_DIR="/backups/jenkins"

REMOTE_USER="ec2@163.14.251.214"

REMOTE_DEST="$REMOTE_USER:$BACKUP_DIR"

LOGFILE="/var/log/jenkins_backup.log"

perform_backup() {
    echo "$(date '+%Y-%m-%d  %H:%M:%S') -   Jenkins backup..." >> "$LOGFILE"
    rsync -avz "$SRC_DIR" "$REMOTE_DEST" >> "$LOGFILE" 2>&1
    if [ $? -eq 0 ]; then
        echo "$(date '+%Y-%m-%d  %H:%M:%S') - Jenkins backup completed successfully." >> "$LOGFILE"
        echo "Jenkins backup completed successfully."
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Jenkins backup encountered errors." >> "$LOGFILE"
        echo "Jenkins backup failed. Please check the log file for more details."
    fi
}

perform_backup
