docker run --rm --name=gitleaks \
  -v "$WORKSPACE:/repo" \
  -v "$WORKSPACE/.gitleaks.toml:/gitleaks.toml" \
  zricethezav/gitleaks:latest \
  detect --source="repo" \
  --report-format json \
  --report-path /repo/gitleaks-report.json \
  --no-git