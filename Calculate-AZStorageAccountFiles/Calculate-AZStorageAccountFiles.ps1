$Context = New-AzStorageContext -StorageAccountName 'NAME OF STORAGE CONTEXT HERE' -StorageAccountKey 'STORAGE ACCOUNT KEY HERE'
$container = Get-AzStorageContainer -name 'NAME OF STORAGE CONTAINER' -Context $Context

$list = Import-CSV 'PATH OF CSV FILE'

$Size = 0
$ExceptionMessage = 0
$ReadItems = 0

foreach ($item in $list) {
    $blob = $null
    try {
        $blob = Get-AzStorageBlob -container container_name -Context $Context -Blob $item.FullPath -ErrorAction Stop
        $size += $blob.Length
        Write-Host "Size of files in bytes: $($Size)" -ForegroundColor Green
        $ReadItems++
        Write-Host "Number of files calculated: $($ReadItems)" -ForegroundColor Blue
    }
    catch {
        Write-Error "File not found..."
        $ExceptionMessage++
        Write-Warning "Number of files not found: $($ExceptionMessage)"
    }
}
