---
title: "{{ env.GITHUB_WORKFLOW }} - GitHub Action is Failing..."
assignees: "{{ payload.sender.login }}"
labels: "bug, enhancement"
---

See [the action log](https://github.com/{{ env.GITHUB_ACTION_REPOSITORY }}/actions/runs/{{ env.GITHUB_RUN_ID }}) for more details.
