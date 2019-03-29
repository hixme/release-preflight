# release-preflight

Script to generate a JIRA ticket release summary based on a specific commit message template. 

```bash
# The commit messages must include:
#   - Ticket type (fix, feat/feature, imp/improvement, hotfix)
#   - JIRA issue key

fix/ABC-1234: Fix something
```

The script displays tickets which are in the `develop` branch, but not the `master` branch.

## Usage

The script relies a domain to be provided. For information on how to determine what that is, see [here](https://developer.atlassian.com/cloud/jira/platform/rest/v3).

You will be prompted for your JIRA username and password. Optionally, you may provide those as environment variables as well:

```bash
JIRA_USERNAME=<username> JIRA_PASSWORD=<password> JIRA_DOMAIN=<mydomain> release-preflight.sh
```

The script assumes your source and target branches to be develop and master, respectively. However, you may override the defaults if source and target branches are provided as environment variables.

```bash
TARGET_BRANCH=develop SOURCE_BRANCH=feat/ABC-1234 release-preflight.sh
```
