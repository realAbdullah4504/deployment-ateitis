#!/bin/bash

# for viewing
# tar -tzvf jenkins-data_2025-07-08_14-15-42.tar.gz

# -------------------------
# Jenkins Backup Script
# -------------------------

# Name of your Jenkins volume
VOLUME_NAME="jenkins-data"

# Where to store the backups on your host
BACKUP_DIR="$HOME/jenkins_backup"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate timestamp
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# Backup filename
BACKUP_FILE="$BACKUP_DIR/${VOLUME_NAME}_${DATE}.tar.gz"

echo "Starting Jenkins volume backup..."

# Run temporary container to tar the volume data
docker run --rm \
  -v $VOLUME_NAME:/data \
  -v $BACKUP_DIR:/backup \
  busybox \
  tar czvf /backup/${VOLUME_NAME}_${DATE}.tar.gz -C /data .

if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $BACKUP_FILE"
else
    echo "Backup FAILED."
fi
