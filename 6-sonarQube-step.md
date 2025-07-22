Now, the next step is to integrate Jenkins with SonarQube.
To do this, please create a Freestyle Project named:
SAST – Revisión de código estático (SonarQube) – Etapa 9
This job must be triggered by the job “Etapa 8Bis” only if it finishes successfully.
Then, this job must connect to SonarQube to perform the static code analysis.
In SonarQube, you need to configure the following settings to achieve these objectives:
✅ Focus on security
✅ Visibility of vulnerabilities and OWASP Top 10 issues
Below are the detailed steps to prepare the Quality Profile and Quality Gate in SonarQube:
________________________________________
✨ Steps to configure the Quality Profile
1️⃣ Log into SonarQube with an administrator account.
2️⃣ In the top menu, go to Quality Profiles.
3️⃣ Search for the main programming language (for example, Java).
4️⃣ On the right side of Sonar way, click Clone.
•	Suggested name:
Sonar way + Seguridad
5️⃣ Enter the new cloned profile.
6️⃣ In the Rules search field, filter and activate all rules with the following tags:
•	Security
•	OWASP Top 10
•	Injection
•	CWE
•	Security Hotspot
(You can select multiple rules and enable them in bulk.)
7️⃣ Confirm that all these rules are active.
8️⃣ Assign this Quality Profile to your project:
•	Go to Projects > select your project.
•	In the left menu, go to Quality Profile.
•	Assign the new profile Sonar way + Seguridad.
________________________________________
✨ Steps to configure the Quality Gate
The Quality Gate defines which conditions will cause the build to fail.
Please create a new Quality Gate and configure it with these parameters:
Metric	Operator	Value	Status
New Vulnerabilities	is greater than	0	Fail
New Security Hotspots	is greater than	0	Fail
New Bugs	is greater than	0	WARN
Maintainability Rating	is worse than	A	WARN

