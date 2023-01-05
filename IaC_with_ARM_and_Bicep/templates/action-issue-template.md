---
title: "{{ env.GITHUB_WORKFLOW }} - GitHub Action is failing..."
labels: bug, enhancement
---

The ARM Template `{{ env.GITHUB_WORKFLOW }}` failed. Please see more details above and fix the issues before pull request:
</br></br>
[+] Start Trigger Type: {{ env.GITHUB_EVENT_NAME }} </br>
[+] Branch Code: {{ env.GITHUB_REF_NAME }}</br>
[+] Code Repository: {{ env.GITHUB_REPOSITORY }}</br>
[+] GitHub Action Job: {{ env.GITHUB_JOB }}</br>
[+] GitHub Action Started by: {{ env.GITHUB_ACTOR }}</br>
[+] Execution Attempt before fail: {{ env.GITHUB_RUN_ATTEMPT }}</br>
[+] Agent Type: {{ env.RUNNER_NAME }}</br>
[+] Agent OS: {{ env.RUNNER_OS }}</br>
[+] OS Architecture: {{ env.RUNNER_ARCH }}</br>
[+] Log Retention in Days: {{ env.GITHUB_RETENTION_DAYS }}</br>
</br>
>**Note** </br>
> See {{ env.GITHUB_SERVER_URL }}/{{ env.GITHUB_REPOSITORY }}/actions/runs/{{ env.GITHUB_RUN_ID }} for more information.
