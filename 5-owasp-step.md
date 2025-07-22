The next step is to integrate Jenkins with OWASP Dependency Check.

Please create a Freestyle Project named:

    SCA – Revisión de dependencias (OWASP) – Etapa 8Bis

This job must be triggered only if the job “SCA – Revisión de dependencias (SNYK) – Etapa 8” completed successfully.

The job SCA – Revisión de dependencias (OWASP) – Etapa 8Bis must:

    Connect to OWASP Dependency Check to scan the dependencies of the project.

    Be able to generate and retrieve the scan report automatically.

    Mark the build as FAIL only if Critical and/or High vulnerabilities are detected.

    If the build fails, Jenkins must automatically send an email notification to the developer who submitted the code and also to the Information Security team.

Important:
Please remember to document everything carefully, including all configurations, steps and notification messages. All notifications and messages must be configured in Spanish.