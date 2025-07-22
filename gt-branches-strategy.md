Yes, that’s correct — that’s the flow we are targeting.

🔹 When the developer pushes to their feature branch, GitLab CI runs validations like checking 
the test folder structure, and can also include local or early-stage checks (e.g., using SonarLint or Snyk in the IDE).

🔹 When the developer creates a merge request to the develop branch, GitLab CI runs again 
to ensure that everything is in place (e.g., test evidence folder exists, basic validations pass, etc.).

🔹 Once the merge to develop is approved and completed, Jenkins is triggered automatically and 
executes Jobs 6 through 10 — these are the core security checks:

    GitLeaks

    Snyk (SCA)

    OWASP Dependency Check

    SonarQube (SAST)

    Uploading results to the portal

That means Jenkins is responsible for the security validation layer, while GitLab handles 
the initial workflow validation and code structure pre-checks.

This separation keeps things clean and scalable as the DevSecOps maturity evolves.