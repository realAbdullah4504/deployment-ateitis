The next step we need to implement is that once the validation in Git completes successfully, Git must communicate with Jenkins and trigger the first Freestyle Project.

We want to configure each task in Jenkins as a Freestyle Project, instead of pipelines or other project types.

The first Freestyle Project must be named:

    “Notificación inicial - Etapa 6”

This job will have a single purpose:

    Receive the notification (the webhook) from Git.

    Immediately trigger the execution of the second Freestyle Project.

The second Freestyle Project must be named:

    “Validación GitLeaks - Etapa 7”

This job must:

    Automatically start after “Notificación inicial - Etapa 6” finishes successfully.

    Communicate with GitLeaks to scan the repository and validate whether there is any exposure of secrets, 
    credentials, passwords, API keys, or other sensitive information in the code.

    Receive from GitLeaks a validation report with the results of the scan.

If GitLeaks detects any credentials, passwords, or similar sensitive data:

    The “Validación GitLeaks - Etapa 7” job must fail automatically.

    Jenkins must immediately notify:

        The development team (the one who performed the initial PUSH).

        The information security team.

This notification must be sent by email automatically and clearly indicate the reason for the failure and the content of the GitLeaks report.

Important:

    All the configuration, job names, and notification messages must be in Spanish.

    Remember to fully document the process, including:

        All Jenkins job configurations.

        Notification settings.

        Any scripts or commands used.

        Any specific permissions or integrations configured.


🎯 Objective

Configure Jenkins so that:

    When GitLab sends the webhook notification (push), it automatically triggers a Freestyle Project called:

        “Notificación inicial - Etapa 6”

    This Freestyle Project starts the second Freestyle Project:

        “Validación GitLeaks - Etapa 7”

    The second job runs Gitleaks, processes the report and sends notifications in case of failure.

🟢 Step 1 – Create Freestyle Project “Notificación inicial - Etapa 6”

    Log into the Jenkins web interface.

    Click “New Item”.

    Name:
    Notificación inicial - Etapa 6

    Project Type:
    Freestyle Project

    Click “OK”.

    In the “General” tab, add a description if desired.

    In “Source Code Management”, leave it empty if it is only a trigger.

    In “Build Triggers”:

        Check “Build when a change is pushed to GitLab”.

        Copy the webhook URL (provided by Jenkins).

        Configure this URL in GitLab (Repository > Settings > Webhooks).

    In “Build”, add a step:

        “Build other projects”.

        In “Projects to build”:
        Validación GitLeaks - Etapa 7

        Check “Trigger only if build is stable”.

🟢 Step 2 – Create Freestyle Project “Validación GitLeaks - Etapa 7”

    Back to Jenkins main page.

    Click “New Item”.

    Name:
    Validación GitLeaks - Etapa 7

    Project Type:
    Freestyle Project

    Click “OK”.

    In “General”, add a description.

    In “Source Code Management”:

        Select Git.

        Repository URL.

        Credentials.

        Branch to scan: e.g. */dev.

    In “Build Triggers”, leave empty (it is triggered by Etapa 6).

    In “Build Environment”, optionally check:

        Delete workspace before build starts.

    In “Build”, add step:

        Execute Shell

        Script:

        echo "Starting scan with Gitleaks..."
        gitleaks detect --source . --no-git -v --report-path gitleaks-report.json --exit-code 1

    In “Post-build Actions”:

        Add Editable Email Notification.

        Configure:

            Recipients: development team + security team.

            Subject: Fallo en Validación Gitleaks - Etapa 7

            Message in Spanish explaining the detection.

            Attach gitleaks-report.json.

🟢 Step 3 – Testing

    Make a test push to GitLab.

    Verify that:

        “Notificación inicial - Etapa 6” runs automatically.

        It triggers “Validación GitLeaks - Etapa 7”.

        If secrets are detected, the build fails.

        The email notification in Spanish is sent.