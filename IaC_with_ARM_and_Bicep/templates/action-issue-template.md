---
title: "{{ env.GITHUB_WORKFLOW }} - GitHub Action is failing..."
labels: arm-ttk-failure
assignees: $payload.sender.login
---

The ARM Template `{{ env.GITHUB_WORKFLOW }}` failed. Please see more details above and fix the issues before pull request:

|           Name             |                  Value                  |
| -------------------------- | --------------------------------------- |
| Start Trigger Type         | {{ env.GITHUB_EVENT_NAME }}             |
| Branch Code                | {{ env.GITHUB_REF_NAME }}               |
| Code Repository            | {{ env.GITHUB_REPOSITORY }}             |
| GitHub Action Job          | {{ env.GITHUB_JOB }}                    |
| GitHub Action Started by   | {{ env.GITHUB_ACTOR }}                  |
| Execution Attempts         | {{ env.GITHUB_RUN_ATTEMPT }}            | 
| Agent Type                 | {{ env.RUNNER_NAME }}                   |
| Agent OS                   | {{ env.RUNNER_OS }}                     |
| OS Architecture            | {{ env.RUNNER_ARCH }}                   |
| Log Retention in Days      | {{ env.GITHUB_RETENTION_DAYS }}         |


>**Note**
> See {{ env.GITHUB_SERVER_URL }}/{{ env.GITHUB_REPOSITORY }}/actions/runs/{{ env.GITHUB_RUN_ID }} for more information.
