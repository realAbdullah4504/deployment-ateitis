#!/bin/bash

# Create backup directory with timestamp
BACKUP_DIR="./gitlab_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Starting GitLab backup at $(date)"

# List of volumes to back up
VOLUMES=("gitlab_config" "gitlab_logs" "gitlab_data")

# Backup each volume
for VOLUME in "${VOLUMES[@]}"; do
    echo "Backing up volume: $VOLUME"
    docker run --rm -v "$VOLUME":/source -v "$(pwd)/$BACKUP_DIR":/backup \
        alpine tar czf "/backup/${VOLUME}.tar.gz" -C /source .
    
    if [ $? -eq 0 ]; then
        echo "Successfully backed up $VOLUME"
    else
        echo "Failed to back up $VOLUME"
        exit 1
    fi
done

echo "GitLab backup completed at $(date)"
echo "Backup files are stored in: $BACKUP_DIR"
