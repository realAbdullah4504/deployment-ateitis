# Ensure clean output
rm -f dependency-check-report.*
npm ci

# Run OWASP Dependency-Check via Docker
# Ensure clean output
rm -f dependency-check-report.*
npm ci

docker run --rm \
  --user 1002:1002 \
  -v /home/ateitis/dependency-check-data:/usr/share/dependency-check/data \
  -v $WORKSPACE:/src \
  owasp/dependency-check:latest \
    --project "SCA-Revision-dependencias-OWASP-8Bis" \
    --scan /src \
    --format HTML \
    --out /src \
    --enableExperimental \
    --failOnCVSS 8
