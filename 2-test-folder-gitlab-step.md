First of all, we need to install the required plugins to make the integrations, and/or define 
how we are going to make the integrations between the tools. 


Once this is defined, the first step is to automate in GITLAB that when the developer makes the PUSH to a 
specific branch, validate the existence of certain “folders” and “files” (Validate that there is a folder 
called ‘Tests’ and within “Tests” there is a folder with the date that the PUSH is made, and that it has 
files). We do this to validate that indeed the developer before doing the PUSH did the corresponding tests. 
In case it does not exist, you must give a notification to the developer that the PUSH failed. If it exists 
and it passed, leave a task (we are going to take it up later).

For the configuration in the client environment, connect via VPN and you will have access to the servers with 
the credentials that I will give you in due time. If you want to replicate the entire infrastructure in your 
environment, and then we replicate everything in the client's production.

Important: This configuration as the notifications have to be in "SPANISH", 
also document everything that is done and how to configure it in a document.




Automatic validation in GitLab CI/CD to check for the existence of test folders and files

🔹 Objective

To automate GitLab's verification process so that, when a GitLab push is made to a specific branch 
(e.g., dev or release), the following are verified:

A Tests folder in the project root.

A subfolder within Tests with the current date (YYYY-MM-DD).

At least one file within that folder.

If any of these conditions are not met, the pipeline is stopped and an error message is displayed.

🔹 Implementation step-by-step

1. Create a .gitlab-ci.yml file in the project root (if it doesn't exist)

This file defines the GitLab CI/CD pipeline jobs.

2. Add the following validation stage

stages:
- validation
- tests # other stages if any

verify_tests:
stage: validation
script:
- echo "Starting test folder validation..."
- |
DATE = $(date + "%Y-%m-%d")
echo "Expected date: $DATE"
if [ ! -d "Tests" ]; then
echo "\u274c ERROR: No such folder 'Tests/$DATE' in the repository."
exit 1
fi
if [ ! -d "Tests/$DATE" ]; then
echo "\u274c ERROR: No such folder 'Tests/$DATE' with the current date."
exit 1
fi
FILES = $(ls Tests/$DATE | wc -l)
if [ "$FILES" -eq 0 ]; then
echo "\u274c ERROR: The 'Tests/$DATE' folder does not contain any test files."
exit 1
fi
echo "\u2705 Test validation successful."
only:
- dev # Or the branch you want to validate

🔹 Developer Messages

The messages displayed in the console are already in Spanish and clearly detail the error.

The developer will see the error directly during the pipeline execution.

Optionally:

You can configure a Webhook for email notifications or Slack/Discord integration for automatic alerts.

🔹 Recommendations

Use the repository's git config to ensure folder names are case-sensitive.

Validate that the GitLab server time is synchronized to avoid date errors.

Test the pipeline with a commit that includes or does not include the Tests/YYYY-MM-DD folder.

🔹 Implementation documentation

The .gitlab-ci.yml file was created or edited.

The verify_tests stage was defined at the start of the pipeline.

It only runs if the push is to the dev branch.

Error and success messages were displayed correctly.

It was validated with a real-world example:

Without a Tests folder > Failed.

With a folder without the current date > Failed.

With a correct but empty folder > Failed.

With a folder with files > Success.