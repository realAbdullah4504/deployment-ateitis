#!/bin/bash
set -e

# 📅 Date paths
TODAY=$(date +%F)
NOW=$(date +%Y%m%d%H%M%S)
JMETER_DIR="$WORKSPACE/Tests/$TODAY/jmeter"

# 📂 Validate test directory exists
if [ ! -d "$JMETER_DIR" ]; then
  echo "❌ ERROR: Directory $JMETER_DIR does not exist"
  exit 1
fi

# 🔢 Determine test number (count of result folders)
TEST_COUNT=$(find "$JMETER_DIR" -maxdepth 1 -type d -name "*_RESULTADO_*" | wc -l)
TEST_NUMBER=$((TEST_COUNT + 1))

# 📁 Create result directory
RESULT_DIR="${JMETER_DIR}/${TEST_NUMBER}_RESULTADO_${NOW}"
mkdir -p "$RESULT_DIR"

# 🐳 Run JMeter Docker container for each .jmx file
for JMX_FILE in "$JMETER_DIR"/*.jmx; do
  [ -e "$JMX_FILE" ] || continue  # Skip if no files

  TEST_NAME=$(basename "$JMX_FILE" .jmx)
  JTL_FILE="${RESULT_DIR}/${TEST_NAME}.jtl"
  REPORT_DIR="${RESULT_DIR}/${TEST_NAME}_report"

  echo "▶️ Running $TEST_NAME..."

  docker run --rm \
    -v "$JMETER_DIR":/tests \
    -v "$RESULT_DIR":/results \
    justb4/jmeter \
    -n -t "/tests/$(basename "$JMX_FILE")" -l "/results/$(basename "$JTL_FILE")"

  # 🧾 Generate HTML report
  mkdir -p "$REPORT_DIR"
  docker run --rm \
    -v "$RESULT_DIR":/results \
    justb4/jmeter \
    -g "/results/$(basename "$JTL_FILE")" -o "/results/$(basename "$REPORT_DIR")"
done

# ✅ Determine overall test status
PASS=true
for JTL in "$RESULT_DIR"/*.jtl; do
  ERRORS=$(grep -c "false" "$JTL" || true)
  if [ "$ERRORS" -gt 0 ]; then
    PASS=false
    break
  fi
done

# 🏷 Rename result folder with PASS/FAIL
STATUS="FAIL"
if $PASS; then
  STATUS="PASS"
fi

FINAL_DIR="${JMETER_DIR}/${TEST_NUMBER}_${STATUS}_${NOW}"
mv "$RESULT_DIR" "$FINAL_DIR"

echo "✅ Tests completed. Results stored in: $FINAL_DIR"

git config user.email "jenkins@example.com"
git config user.name "jenkins"
git add .
git commit -m "Add JMeter results for $TODAY run number $TEST_NUMBER"