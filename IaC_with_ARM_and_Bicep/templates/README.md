```mermaid
gitGraph
    checkout main
    commit id: "Initial Commit"
    branch develop
    commit id:" "
    branch feature
    commit id:"   "
    commit id:"  "
    checkout develop
    merge feature
    checkout main
    merge develop id: "Pull Request with approval"
 ```
