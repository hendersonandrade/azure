<#
.SYNOPSIS
    Gera um relatorio das Route Tables do Azure exibindo a propagacao de rotas do gateway.

.DESCRIPTION
    Percorre as subscriptions acessiveis (ou apenas as informadas em -SubscriptionId) e coleta
    todas as Route Tables, apresentando em tela um relatorio moderno com as colunas:
        - subscription       : nome da subscription
        - route              : nome da Route Table
        - propagateGateway   : True (propagacao habilitada)  -> destacado em VERMELHO
                               False (propagacao desabilitada) -> destacado em VERDE

    No Azure a propriedade nativa e "disableBgpRoutePropagation".
    propagateGateway = NOT disableBgpRoutePropagation.

.PARAMETER SubscriptionId
    Um ou mais IDs de subscription para filtrar. Se omitido, considera todas as subscriptions habilitadas.

.EXAMPLE
    ./Get-RouteTableReport.ps1

.EXAMPLE
    ./Get-RouteTableReport.ps1 -SubscriptionId '00000000-0000-0000-0000-000000000000'

.NOTES
    Requer o modulo Az (Az.Accounts, Az.Network) e uma sessao autenticada (Connect-AzAccount).
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string[]]$SubscriptionId
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

function Test-Prerequisites {
    foreach ($module in @('Az.Accounts', 'Az.Network')) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            throw "Modulo '$module' nao encontrado. Instale com: Install-Module Az -Scope CurrentUser"
        }
    }

    $context = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $context) {
        throw "Nenhuma sessao Azure ativa. Execute 'Connect-AzAccount' antes de rodar o script."
    }
}

function Get-TargetSubscriptions {
    param([string[]]$SubscriptionId)

    $subscriptions = Get-AzSubscription -ErrorAction Stop | Where-Object { $_.State -eq 'Enabled' }

    if ($SubscriptionId) {
        $subscriptions = $subscriptions | Where-Object { $SubscriptionId -contains $_.Id }
    }

    return $subscriptions
}

function Get-RouteTableData {
    param([object[]]$Subscriptions)

    $records = [System.Collections.Generic.List[pscustomobject]]::new()

    foreach ($subscription in $Subscriptions) {
        Write-Host ("  -> Coletando Route Tables em '{0}'..." -f $subscription.Name) -ForegroundColor DarkGray
        $null = Set-AzContext -SubscriptionId $subscription.Id -ErrorAction Stop

        $routeTables = Get-AzRouteTable -ErrorAction Stop
        foreach ($rt in $routeTables) {
            # propagateGateway = inverso de disableBgpRoutePropagation
            $propagate = -not [bool]$rt.DisableBgpRoutePropagation

            $records.Add([pscustomobject]@{
                    Subscription     = $subscription.Name
                    Route            = $rt.Name
                    PropagateGateway = $propagate
                })
        }
    }

    return $records
}

function Show-Report {
    param([System.Collections.Generic.List[pscustomobject]]$Records)

    if (-not $Records -or $Records.Count -eq 0) {
        Write-Host "`nNenhuma Route Table encontrada." -ForegroundColor Yellow
        return
    }

    # Larguras dinamicas das colunas para alinhar a tabela.
    $subHeader = 'subscription'
    $routeHeader = 'route'
    $propHeader = 'propagateGateway'

    $subWidth = ([int]($Records.Subscription | Measure-Object -Property Length -Maximum).Maximum, $subHeader.Length | Measure-Object -Maximum).Maximum
    $routeWidth = ([int]($Records.Route | Measure-Object -Property Length -Maximum).Maximum, $routeHeader.Length | Measure-Object -Maximum).Maximum
    $propWidth = $propHeader.Length

    $borderTop = '+-{0}-+-{1}-+-{2}-+' -f ('-' * $subWidth), ('-' * $routeWidth), ('-' * $propWidth)

    Write-Host ""
    Write-Host "==================== Relatorio de Route Tables ====================" -ForegroundColor Cyan
    Write-Host ""

    # Cabecalho
    Write-Host $borderTop -ForegroundColor DarkGray
    Write-Host '| ' -NoNewline -ForegroundColor DarkGray
    Write-Host ($subHeader.PadRight($subWidth)) -NoNewline -ForegroundColor White
    Write-Host ' | ' -NoNewline -ForegroundColor DarkGray
    Write-Host ($routeHeader.PadRight($routeWidth)) -NoNewline -ForegroundColor White
    Write-Host ' | ' -NoNewline -ForegroundColor DarkGray
    Write-Host ($propHeader.PadRight($propWidth)) -NoNewline -ForegroundColor White
    Write-Host ' |' -ForegroundColor DarkGray
    Write-Host $borderTop -ForegroundColor DarkGray

    # Linhas
    foreach ($record in ($Records | Sort-Object Subscription, Route)) {
        $propColor = if ($record.PropagateGateway) { 'Red' } else { 'Green' }
        $propText = $record.PropagateGateway.ToString()  # True / False

        Write-Host '| ' -NoNewline -ForegroundColor DarkGray
        Write-Host ($record.Subscription.PadRight($subWidth)) -NoNewline -ForegroundColor Gray
        Write-Host ' | ' -NoNewline -ForegroundColor DarkGray
        Write-Host ($record.Route.PadRight($routeWidth)) -NoNewline -ForegroundColor Gray
        Write-Host ' | ' -NoNewline -ForegroundColor DarkGray
        Write-Host ($propText.PadRight($propWidth)) -NoNewline -ForegroundColor $propColor
        Write-Host ' |' -ForegroundColor DarkGray
    }

    Write-Host $borderTop -ForegroundColor DarkGray

    # Resumo
    $total = $Records.Count
    $propagating = ($Records | Where-Object { $_.PropagateGateway }).Count
    $notPropagating = $total - $propagating

    Write-Host ""
    Write-Host ("Total de Route Tables : {0}" -f $total) -ForegroundColor Cyan
    Write-Host ("  Propagando gateway  : {0}" -f $propagating) -ForegroundColor Red
    Write-Host ("  Sem propagacao      : {0}" -f $notPropagating) -ForegroundColor Green
    Write-Host ""
}

# --------------------------- Execucao ---------------------------
Test-Prerequisites

Write-Host "`nColetando subscriptions..." -ForegroundColor Cyan
$subscriptions = Get-TargetSubscriptions -SubscriptionId $SubscriptionId

if (-not $subscriptions) {
    Write-Host "Nenhuma subscription encontrada para os filtros informados." -ForegroundColor Yellow
    return
}

$records = Get-RouteTableData -Subscriptions $subscriptions
Show-Report -Records $records
