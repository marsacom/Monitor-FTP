#Variables to set
$path = 'C:\Users\bkukla\OneDrive - S&S Industrial Surplus LLC\Desktop\Dev\_Projects'
$identity = 'SSIS\bkukla'

Get-ChildItem -Directory -Path $path -Recurse -Depth 2 |
    Foreach-Object {  
        $Acl = Get-Acl -Path $_.FullName  
        foreach ($Access in $acl.Access) {
            if($Access.IdentityReference -ne $identity){Continue}
            
            #if($oldDate -le $_.LastWriteTime) {
            #    $newDate = $_.LastWriteTime
            #}else{
            #    $newDate = $oldDate
            #}

            $Properties = [ordered]@{  
                                        'FolderName'        = $_.FullName   
                                        'LastWriteTime'     = $_.LastWriteTime  
                                        'OldDate'           = $oldDate
                                        'NewDate'           = $newDate
                                    }  
            [PSCustomObject]$Properties  
        }  
    } | Export-Csv -Path "C:\temp\FolderPermissions.csv" 