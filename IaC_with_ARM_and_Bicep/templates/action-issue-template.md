---
title: "{{ env.GITHUB_WORKFLOW }} - GitHub Action is failing..."
labels: bug, enhancement
---


- GITHUB_ACTION: {{ env.GITHUB_ACTION }}
- GITHUB_ACTION_PATH: {{ env.GITHUB_ACTION_PATH }}
- GITHUB_ACTION_REPOSITORY: {{ env.GITHUB_ACTION_REPOSITORY }}
- GITHUB_ACTIONS: {{ env.GITHUB_ACTIONS }}
- GITHUB_HEAD_REF: {{ env.GITHUB_HEAD_REF }}
- GitHub Action Started by: {{ payload.sender.login }}
- GITHUB_REF_NAME: {{ env.GITHUB_REF_NAME }}
- GITHUB_REPOSITORY: {{ env.GITHUB_REPOSITORY }}
- GITHUB_RUN_ATTEMPT: {{ env.GITHUB_RUN_ATTEMPT }}
- RUNNER_OS: {{ env.RUNNER_OS }}
- GITHUB_ACTOR: {{ env.GITHUB_ACTOR }}
- GITHUB_BASE_REF: {{ env.GITHUB_BASE_REF }}
- GITHUB_EVENT_NAME: {{ env.GITHUB_EVENT_NAME }}
- GITHUB_EVENT_PATH: {{ env.GITHUB_EVENT_PATH }}
- GITHUB_JOB: {{ env.GITHUB_JOB }}
- GITHUB_RETENTION_DAYS: {{ env.GITHUB_RETENTION_DAYS }}
- RUNNER_ARCH: {{ env.RUNNER_ARCH }}
- RUNNER_NAME: {{ env.RUNNER_NAME }}
- RUNNER_OS: {{ env.RUNNER_OS }}


See [ActionLog]({{ env.GITHUB_SERVER_URL }}/{{ env.GITHUB_REPOSITORY }}/actions/runs/{{ env.GITHUB_RUN_ID }} for more information.
