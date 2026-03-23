# =========================================================
# CONFIGURAÇÕES
# =========================================================
$ExcelPath       = "C:\Temp\VNets-Input.xlsx"
$ExecuteChanges  = $false   # $true = aplica tag | $false = simulação
$ConnectToAzure  = $true

# Nome da tag que será criada/atualizada
$TagName = "Network"

# =========================================================
# PRÉ-REQUISITOS
# =========================================================
# Install-Module Az -Scope CurrentUser -Force
# Install-Module ImportExcel -Scope CurrentUser -Force

$ErrorActionPreference = "Stop"

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

function Get-NormalizedColumnName {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    return (($Name -replace '[^a-zA-Z0-9]', '').ToLowerInvariant())
}

function Get-ColumnValue {
    param(
        [Parameter(Mandatory)]
        [psobject]$Row,

        [Parameter(Mandatory)]
        [string[]]$CandidateNames
    )

    $properties = $Row.PSObject.Properties

    foreach ($candidateName in $CandidateNames) {
        $normalizedCandidate = Get-NormalizedColumnName -Name $candidateName

        foreach ($property in $properties) {
            if ((Get-NormalizedColumnName -Name $property.Name) -eq $normalizedCandidate) {
                return [string]$property.Value
            }
        }
    }

    return $null
}

# =========================================================
# VALIDAÇÕES
# =========================================================
if (-not (Test-Path $ExcelPath)) {
    throw "Arquivo Excel não encontrado: $ExcelPath"
}

if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
    throw "Módulo Az não encontrado. Instale com: Install-Module Az -Scope CurrentUser -Force"
}

if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    throw "Módulo ImportExcel não encontrado. Instale com: Install-Module ImportExcel -Scope CurrentUser -Force"
}

Import-Module Az.Accounts -ErrorAction Stop
Import-Module Az.Resources -ErrorAction Stop
Import-Module ImportExcel -ErrorAction Stop

# =========================================================
# AUTENTICAÇÃO
# =========================================================
if ($ConnectToAzure) {
    Write-Log "Autenticando no Azure..."
    Connect-AzAccount -ErrorAction Stop | Out-Null
}

# =========================================================
# LEITURA DO EXCEL
# =========================================================
Write-Log "Lendo arquivo Excel: $ExcelPath"

$rows = Import-Excel -Path $ExcelPath

if (-not $rows -or $rows.Count -eq 0) {
    throw "Nenhuma linha encontrada no Excel."
}

# =========================================================
# PROCESSAMENTO
# =========================================================
$lineNumber = 1

foreach ($row in $rows) {
    $lineNumber++

    try {
        $subscriptionName = Get-ColumnValue -Row $row -CandidateNames @(
            'subscriptionName',
            'subcriptionName'
        )

        $vnetName = Get-ColumnValue -Row $row -CandidateNames @(
            'VNetName',
            'vnetName'
        )

        $resourceId = Get-ColumnValue -Row $row -CandidateNames @(
            'ResourceID',
            'resourceId'
        )

        $tagValue = Get-ColumnValue -Row $row -CandidateNames @(
            'tagNetwork',
            'TagNetwork'
        )

        if (
            [string]::IsNullOrWhiteSpace($subscriptionName) -or
            [string]::IsNullOrWhiteSpace($resourceId) -or
            [string]::IsNullOrWhiteSpace($tagValue)
        ) {
            Write-Log "Linha $lineNumber ignorada (dados incompletos). Verifique se as colunas subscriptionName, ResourceID e tagNetwork estão preenchidas." "WARN"
            continue
        }

        Write-Log "Processando linha $lineNumber`: $vnetName ($subscriptionName)"

        # Obtém subscription
        $subscription = Get-AzSubscription | Where-Object { $_.Name -eq $subscriptionName }

        if (-not $subscription) {
            Write-Log "Subscription não encontrada: '$subscriptionName'" "ERROR"
            continue
        }

        Set-AzContext -SubscriptionId $subscription.Id | Out-Null

        # Obtém recurso atual (para preservar outras tags)
        $resource = Get-AzResource -ResourceId $resourceId -ErrorAction Stop

        $newTags = @{}

        if ($resource.Tags) {
            foreach ($tag in $resource.Tags.GetEnumerator()) {
                $newTags[$tag.Key] = $tag.Value
            }
        }

        $newTags[$TagName] = $tagValue

        if (-not $ExecuteChanges) {
            Write-Log "[SIMULAÇÃO] Aplicar tag '$TagName=$tagValue' no recurso '$vnetName'" "INFO"
            continue
        }

        Write-Log "Aplicando tag '$TagName=$tagValue' no recurso '$vnetName'"

        Set-AzResource `
            -ResourceId $resourceId `
            -Tag $newTags `
            -Force `
            -ErrorAction Stop | Out-Null

        Write-Log "Tag aplicada com sucesso em '$vnetName'" "SUCCESS"
    }
    catch {
        Write-Log "Erro na linha $lineNumber`: $($_.Exception.Message)" "ERROR"
    }
}

Write-Log "Processamento concluído."
