---
title: "{{ env.GITHUB_WORKFLOW }} - GitHub Action is failing..."
labels: bug, enhancement
---

- URL of Issue: {{ steps.create-issue.outputs.url }}
- Assignees: {{ payload.sender.login }}
