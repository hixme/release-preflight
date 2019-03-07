# release-preflight

Script to generate a release ticket summary 

## Usage

```bash
JIRA_DOMAIN=<mydomain> release-preflight.sh
```

The script relies a domain environment variable to be passed. For information on how to determine what that is, see [here](https://developer.atlassian.com/cloud/jira/platform/rest/v3).

You will be prompted for your JIRA username and password. Optionally, you may provide those as environment variables as well:

```bash
JIRA_USERNAME=<username> JIRA_PASSWORD=<password> JIRA_DOMAIN=<mydomain> release-preflight.sh
```
