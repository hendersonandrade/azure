```mermaid
gitGraph
    checkout main
    commit id: "Initial Commit"
    branch develop
    commit id:"1"
    branch feature
    commit id:"2"
    commit id:"3"
    checkout develop
    merge feature id: "4"
    checkout main
    merge develop id: "Pull Request with approval"
 ```
