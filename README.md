# AzureCorePolicy
![Maintainer](https://img.shields.io/badge/Maintainer-AzurePolicyTeam-blue)

This repository is used to store ARM and Bicep templates already approved and compliant with ExxonMobil policies.
All the templates are reusable and can be used to deploy resource in Azure environment.

For more information about policies deployed in Azure environment of ExxonMobil see the link: https://gotocloud.xom.cloud/cloudwiki/docs/AzurePolicies/PolicyDevelopmentStrategy.html

## Table of Contents

## Getting Started

    .
    ├── templates
    │    ├── StorageAccount                             # Folder containing all the ARM and Bicep template for Storage Account
    │    │  ├── storage_account.json                    # Main file of ARM Template for Storage Account provisioning
    │    │  ├── storage_account.parameters.json         # Parameters file of Storage Account provisioning (can be used by ARM or Bicep)
    │    │  ├── storage_accounts.bicep                  # Main file of Bicep for Storage Account provisioning
    │    │  ├── README.md                               # Documentation file with instructions to use Storage Account templates
    │    ├── VirtualMachine                             # Folder containing all the ARM and Bicep template for Virtual Machines
    │    │  ├── virtual_machine.json                    # Main file of ARM Template for Virtual Machine provisioning
    │    │  ├── virtual_machine.parameters.json         # Parameters file of Virtual Machine provisioning (can be used by ARM or Bicep)
    │    │  ├── virtual_machine.bicep                   # Main file of Bicep for Virtual Machine provisioning
    │    │  ├── README.md                               # Documentation file with instructions to use Virtual Machine templates
    │    ├── ...
    └── README.md                                       # Documentation file with instructions about this repository
    
## How to Contribute

### Best Practices

### Git Workflow

This repository has some controls to avoid that a commit can be made directly in main branch. To contribute on this repository follow the steps mentioned below:

1. Clone the repository locally using a IDE (we recomend the use of Visual Studio Code).
2. Create a new branch using the standard "feature/[Provider]-[ResourceType]" (example: feature/Microsoft.Compute-VirtualMachine). To see the list of providers available, see the link: https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers
3. Publish your recently created branch
4. Do the changes in code and publish changes to branch created
5. Create a pull request from your branch to develop branch
<br><br/>
**Note**
    From this step on, all actions until publication in production will take place in automated way. If the code has a validation error at merge time in develop branch, an issue will gonna be created and assigned to requestor to solve the code in feature branch and do pull request again.

<p align="center">
  <img src="/assets/images/GitFlowOverview.png">
</p>


## Questions and Answers
<details>
<summary><b>1) What is ARM Template?</b></summary>
<p>
ARM Template are declarative JSON files that define resources configuration in Azure Cloud Provider and can be used to implement Infrastructure as Code using Azure Resource Manager architecture.

![ARM Processing](/assets/images/ARMProcessing.png)

</p>
</details>

<details>
<summary><b>2) What is Bicep?</b></summary>
<p>
           
</p>
</details>

<details>
<summary><b>3) What is the benefits of using Infrastructure as Code with ARM/Bicep Template?</b></summary>
<p>
           
</p>
</details>
