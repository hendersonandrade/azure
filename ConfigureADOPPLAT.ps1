function New-PowerPlatformAppRegistration {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$AzureAppName,                

        [Parameter()]
        [string] $TenantId
    )

    # Connecting to Azure AD to create app registration

    # Validating the requirements to connect in Azure AD

    Write-Host "`t-------------------------------------------------------------------------------------------" -ForegroundColor Blue
    Write-Host "`t[-] Connecting in Azure AD and registering Power Platform Build Tools App" -ForegroundColor Blue
    Write-Host "`t-------------------------------------------------------------------------------------------" -ForegroundColor Blue

    if (Get-InstalledModule AzureAD -ErrorAction SilentlyContinue) {
        Write-Host "`t [SUCCESS]: Module Azure AD found in the environment..." -ForegroundColor Green        
    
        try {
            
            if ($TenantId) { 
                Connect-AzureAD -TenantId $TenantId -ErrorAction Stop
                Write-Host "`t [SUCCESS]: Successfuly logged in Azure AD environment..." -ForegroundColor Green            
            }
            
            else {
                Connect-AzureAD -ErrorAction Stop
                Write-Host "`t [SUCCESS]: Successfuly logged in Azure AD environment..." -ForegroundColor Green
            }
        }
        catch {
            Write-Host "`t [Connect Azure AD]: $($Error[0])..." -ForegroundColor Red
            break
        }    
    }

    else {
        Write-Host "`t[INFO]: Installing AzureAD module in the environment..." -ForegroundColor Blue
        Install-Module AzureAD -Verbose -Scope CurrentUser

        try {
            if ($TenantId) { 
                Connect-AzureAD -TenantId $TenantId -ErrorAction Stop
                Write-Host "`t [SUCCESS]: Successfuly logged in Azure AD environment..." -ForegroundColor Green            
            }
            
            else {
                Connect-AzureAD -ErrorAction Stop
                Write-Host "`t [SUCCESS]: Successfuly logged in Azure AD environment..." -ForegroundColor Green
            }
        }
        
        catch {
            Write-Host "`t [ERROR]: $($Error[0])" -ForegroundColor Red
            break
        }    
    }

    # Creating the App Registration in Azure AD
    
    Write-Host "`t [INFO]: Creating $($AzureAppName) Registration in Azure AD..." -ForegroundColor Blue

    if (!(Get-AzureADApplication -Filter "DisplayName eq '$($AzureAppName)'")) {
        try {
            New-AzureADApplication -DisplayName $AzureAppName -ErrorAction Stop
            Write-Host "`t [SUCCESS]: $($AzureAppName) successfully registered in Azure AD..." -ForegroundColor Green
        }
        catch {
            Write-Host "`t [ERROR]: $($Error[0])..." -ForegroundColor Red
            break
        }        
    }

    else {
        Write-Host "`t [ERROR]: $($AzureAppName) already exist in the environment with this name, please change name and try again..." -ForegroundColor Red
        break
    }

    # Adding required permissions to App Registration
    Write-Host "`t [INFO]: Getting App Information for $($AzureAppName) in Azure AD..." -ForegroundColor Blue
    $AzADAppObj = Get-AzureADApplication -Filter "DisplayName eq '$($AzureAppName)'"
    
    Write-Host "`t [INFO]: Adding Az.Resources module in environment..." -ForegroundColor Blue

    if (Get-InstalledModule Az.Resources -ErrorAction SilentlyContinue) {
        Write-Host "`t [SUCCESS]: Module Az.Resources AD found in the environment..." -ForegroundColor Green    
    }

    else {
        Write-Host "`t[INFO]: Installing Az.Resources module in the environment..." -ForegroundColor Blue
        try {
            Install-Module Az.Resources -Verbose -Scope CurrentUser -Confirm:$false -Force
            Write-Host "`t[SUCCESS]: Successfully installed Az.Resources module in the environment..." -ForegroundColor Green -ErrorAction Stop
        }
        catch {
            Write-Host "`t [ERROR]: $($Error[0])..." -ForegroundColor Red
            break        
        }
        
    }

    Write-Host "`t [INFO]: Adding required API permissions for $($AzureAppName) in Azure AD..." -ForegroundColor Blue

    try {
        $graphEnabledEnv = Get-AzEnvironment -Name AzureCloud
        $graphEnabledEnv.Name = "AzureCloudGraph"
        $graphEnabledEnv | Add-AzEnvironment -MicrosoftGraphEndpointResourceId "https://graph.microsoft.com/" -MicrosoftGraphUrl "https://graph.microsoft.com/v1.0/"
        Start-Sleep 60
        Connect-AzAccount -Environment "AzureCloudGraph" -ErrorAction Stop
        Add-AzADAppPermission -ObjectId $AzADAppObj.ObjectId -ApiId 00000007-0000-0000-c000-000000000000 -PermissionId 78ce3f0f-a1ce-49c2-8cde-64b5c0896db4 -ErrorAction Stop
        Add-AzADAppPermission -ObjectId $AzADAppObj.ObjectId -ApiId 82f77645-8a66-4745-bcdf-9706824f9ad0 -PermissionId 4ae1b148-ab4d-496d-8183-9292090fcca4 -ErrorAction Stop
        Write-Host "`t [SUCCESS]: API permissions for $($AzureAppName) configured successfuly in Azure AD..." -ForegroundColor Green
    }
    catch {
        Write-Host "`t [ERROR]: $($Error[0])..." -ForegroundColor Red
    }

    try{
        $startDate = Get-Date
        $endDate = $startDate.AddYears(2)
        $aadAppsecret = New-AzureADApplicationPasswordCredential -ObjectId $AzADAppObj.ObjectId -CustomKeyIdentifier "ADO Pipeline Service Connection" -StartDate $startDate -EndDate $endDate -ErrorAction Stop        
        Write-Host "`t [SUCCESS]: Secret created successfuly for $($AzureAppName) ..." -ForegroundColor Green
    }
    catch{
        Write-Host "`t [ERROR]: $($Error[0])..." -ForegroundColor Red
    }

    $AADAppSecretID = Get-AzureADApplicationPasswordCredential -ObjectId $AzADAppObj.ObjectId

    Write-Host "-------------------------------------------------------------------------------------------" -ForegroundColor Blue
    Write-Host "`t`t Configuration Summary for App Registration in Azure AD" -ForegroundColor Blue
    Write-Host "-------------------------------------------------------------------------------------------" -ForegroundColor Blue
    
    Write-Host "`n [Success]: Installation of required tools: " -ForegroundColor Green
    Write-Host "`t [+] Az.Resources (PowerShell Module)"
    Write-Host "`t [+] AzureAD (PowerShell Module)"
    
    Write-Host "`n [Success]: Connection in Azure AD Environment..." -ForegroundColor Green
    
    Write-Host "`n [Success]: Connection in MS Graph API..." -ForegroundColor Green
        
    Write-Host "`n [Success]: App Registration $($AzureAppName) created in Azure AD Environment:" -ForegroundColor Green
    Write-Host "`t [+] App Name:" $($AzADAppObj).DisplayName
    Write-Host "`t [+] App Object Id:" $($AzADAppObj).ObjectId
    Write-Host "`t [+] App Id:" $($AzADAppObj).AppId
    Write-Host "`t [+] App SignIn Audience:" $($AzADAppObj).SignInAudience

    Write-Host "`n [Success]: Required API Permissions added at App Registration:" -ForegroundColor Green
    Write-Host "`t  ----------------------------------------------------------------" -ForegroundColor DarkMagenta
    Write-Host "`t |    API Permission name    |   Type    | Admin Consent Required |" -ForegroundColor DarkMagenta
    Write-Host "`t  ----------------------------------------------------------------" -ForegroundColor DarkMagenta
    Write-Host "`t |       Dynamics CRM        | Delegated |           No           |"
    Write-Host "`t | PowerApps Runtime Service | Delegated |           No           |"
    Write-Host "`t  ----------------------------------------------------------------" -ForegroundColor DarkMagenta
        
    Write-Host "`n [Success]: Client Secret created for App Registration $($AzureAppName):" -ForegroundColor Green
    Write-Host "`t [+] Secret ID:" $($AADAppSecretID).KeyId
    Write-Host "`t [+] Secret Value:" $($aadAppsecret).Value
    Write-Host "`t [+] Secret Start Date:" $($aadAppsecret).StartDate
    Write-Host "`t [+] Secret End Date:" $($aadAppsecret).EndDate

    Write-Host "`n-------------------------------------------------------------------------------------------" -ForegroundColor Blue

}

New-PowerPlatformAppRegistration -AzureAppName 'Teste-PowerPlat008' -TenantId '0fabda3f-44f7-44ab-a619-3f9e3713f357'