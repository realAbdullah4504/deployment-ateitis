#!/bin/bash
set -e

# Get today's date
DATE=$(date +'%Y-%m-%d')

git config user.email "jenkins@ci.com"
git config user.name "Jenkins CI"

# Prepare the target folder structure
TARGET_DIR="Tests/${DATE}/Build Reports"

echo "Creating target folder: ${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"

# Copy reports into the target folder
echo "Copying reports..."

# Only copy if source folders exist
[ -d Etapa7Reports ] && cp -r Etapa7Reports/* "${TARGET_DIR}/" || echo "Etapa7Reports not found, skipping"
[ -d Etapa8Reports ] && cp -r Etapa8Reports/* "${TARGET_DIR}/" || echo "Etapa8Reports not found, skipping"
[ -d Etapa8BReports ] && cp -r Etapa8BReports/* "${TARGET_DIR}/" || echo "Etapa8BReports not found, skipping"

if [ -f Etapa9Reports/.scannerwork/report-task.txt ]; then
    cp Etapa9Reports/.scannerwork/report-task.txt "${TARGET_DIR}/sonar-report.txt"
else
    echo "Etapa9Reports/.scannerwork/report-task.txt not found, skipping"
fi

# Remove any duplicate file copied under the old name
rm -f "${TARGET_DIR}/report-task.txt"
rm -rf Etapa7Reports Etapa8Reports Etapa8BReports Etapa9Reports

echo "Reports collected into: ${TARGET_DIR}"

if [ -f .git/MERGE_HEAD ]; then
  echo "Merge in progress — resolving by keeping our report files"
  git add ${TARGET_DIR}/*
  git commit -m "Resolve merge conflict and add reports"
fi