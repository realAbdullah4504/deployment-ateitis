#!/bin/bash

# -----------------------------
# Jenkins Restore Script
# -----------------------------

# CONFIGURATION

# Name of your Jenkins volume
VOLUME_NAME="jenkins-data"

# Path to your tar.gz backup archive
BACKUP_ARCHIVE="/home/ateitis/jenkins/jenkins-data_2025-07-08_12-28-34.tar.gz"

# Temporary folder for extracting data
TEMP_RESTORE_DIR="$HOME/jenkins_restore"

# -----------------------------
# Start Restore
# -----------------------------

echo "Starting Jenkins restore..."

# Create volume if it doesn't exist
if ! docker volume inspect $VOLUME_NAME >/dev/null 2>&1; then
    echo "Creating Docker volume: $VOLUME_NAME"
    docker volume create $VOLUME_NAME
else
    echo "Docker volume $VOLUME_NAME already exists."
fi

# Create temporary restore folder
mkdir -p "$TEMP_RESTORE_DIR"

# Extract backup archive to temp folder
echo "Extracting archive to temp directory..."
tar -xzvf "$BACKUP_ARCHIVE" -C "$TEMP_RESTORE_DIR"

# Copy extracted files into Docker volume
echo "Copying data into Docker volume..."
docker run --rm \
    -v $VOLUME_NAME:/data \
    -v $TEMP_RESTORE_DIR:/backup \
    busybox \
    sh -c "cd /backup && tar cf - . | tar xf - -C /data"

echo "Cleaning up temporary restore directory..."
rm -rf "$TEMP_RESTORE_DIR"

echo "✅ Jenkins data restored successfully into volume: $VOLUME_NAME"
