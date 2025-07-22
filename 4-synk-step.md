The next step is to integrate Jenkins with Snyk.

Please create a Freestyle Project named:

    SCA – Revisión de dependencias (SNYK) – Etapa 8

This job must be triggered only if the job “Validación GitLeaks – Etapa 7” completed successfully.

The job SCA – Revisión de dependencias (SNYK) – Etapa 8 must:

    Connect to Snyk.io to analyze dependency vulnerabilities.

    Register in Snyk.io using the email address devsecops@ateitiscorp.com (you should have received an invitation email from the ateitiscorp workspace—please check your inbox to access).

    Be able to retrieve the scan report automatically from Snyk.io.

    Mark the build as FAIL only if there are Critical and/or High vulnerabilities.

    If the build fails, Jenkins must automatically send an email notification to the developer who submitted the code and also to the Information Security team.
