# 🔒 GitLab CI/CD Step: Validate Test Server Deployment (Post Security Reports)

---

## ✅ Objective

Automate the validation of the following before running automated tests:

1. A manual deployment was performed on the corresponding test server.
2. A file named `informacion_server.txt` exists in the following path:
   ```
   /Tests/YYYY-MM-DD/Server test/informacion_server.txt
   ```
3. The file contains a **valid IP address**.
4. If the validation passes, the next Jenkins Freestyle Job is triggered (next step..).

---

## 📁 Expected Repository Structure

```
Tests/
└── 2025-07-12/
    └── Server test/
        └── informacion_server.txt  # ← must contain a valid IP
```

---

## 🔧 Step-by-step GitLab CI/CD Configuration

### 1. Add a new stage to `.gitlab-ci.yml`

```yaml
stages:
  - validate-deploy-info
  - run-tests  # next steps

validate_test_server_info:
  stage: validate-deploy-info
  script:
    - echo "Validating server deployment file..."
    - FECHA=$(date +"%Y-%m-%d")
    - ARCHIVO="Tests/$FECHA/Server test/informacion_server.txt"

    # Validate file exists
    - if [ ! -f "$ARCHIVO" ]; then
        echo "❌ ERROR: File $ARCHIVO not found.";
        exit 1;
      fi

    # Validate file contains a valid IP
    - IP=$(cat "$ARCHIVO")
    - echo "📄 IP found: $IP"
    - if ! [[ "$IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "❌ ERROR: File does not contain a valid IP address.";
        exit 1;
      fi

    - echo "✅ Validation passed. Triggering Jenkins job..."
  only:
    - dev  # or the preferred branch
```

---

## 📩 Notifications

You can add notification hooks to inform the developer (email, Slack, etc.) if the validation fails.

---

## 📘 Prerequisites


1. Developer or QA responsible for generating `informacion_server.txt` after the manual deployment.

---

## 📌 Summary

This step ensures that the application is deployed on a real test server and the required information is uploaded before executing automated test jobs.
