#!/bin/bash

DATE=$(date +%F)

tar -czf backups/log_backup_$DATE.tar.gz /var/log

echo "Backup created successfully"
