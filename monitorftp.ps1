#Variables to set
$path = 'R:\PhotoSync'
$today = Get-Date
$days_subtract = -1
$yesterday = $today.AddDays($days_subtract)
$date = 0

Get-ChildItem -Directory -Path $path |
    Foreach-Object {  
        if($_.LastWriteTime -ge $date){
            $date = $_.LastWriteTime
        }

        $Properties = [ordered]@{  
                                    'Folder'        = $_.FullName   
                                    'Last Write Time'     = $_.LastWriteTime 
                                }  
        [PSCustomObject]$Properties  

    } | Export-Csv -Path "C:\temp\FolderPermissions.csv" -NoTypeInformation

if($date -lt $yesterday){
    Write-Host "Directory $path has not had files uploaded in $($days_subtract*-1) day(s) - Most recent upload : $date"
}else{
    Write-Host "Directory $path is to date - Most recent upload : $date"
}

