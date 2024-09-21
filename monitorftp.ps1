# Monitor-FTP
#
# A simgple powershell script, designed to be set as a scheduled task for monitoring a directory 
# for upload times and alert through email if files have not been uploaded in a set amount of time.
# The script is designed to be used for monitoring a directory where files are being uploaded through FTP
# to verify files are being uploaded on a day to day basis but can be used for any directory where files are being uploaded  
# and with some minor customization and tweaks you can get this working for your specific use case.
#
# This script uses MailSlurp and their email API for sending emails. This is because the previous preferred cmdlet for sending emails 
# through powershell (Send-MailMessage) is no longer supported and does not allow for secure connection. 
#
# Be sure to change any needed variables below...
#
# - Author : Brayden Kukla, 2024

# Variables to be set
$path = 'R:\PhotoSync' # The path you wish to monitor
$recipient = 'brayden@ssisurplus.com' # The recipient email of the status updates
$inbox_index = 0 # The inbox index of your MailSlurp inbox, only change if using a custom created inbox

# Send a status email to the designated recipient to notify that the directory is not being uploaded to
function SendStatusEmail {
    # Set the API KEY
    $apiKey = $Env:MAIL_API_KEY

    # Get the inbox/sender to send with
    $inboxes = Invoke-WebRequest -Uri "https://api.mailslurp.com/inboxes" -Headers @{"x-api-key"=$apiKey;} | ConvertFrom-Json
    $inboxId = $inboxes[$inbox_index].id # If using a custom created inbox be sure to change the index of this value
    
    # Set params and send the status email
    $params = @{
     "to"=@($recipient);
     "subject"="WARNING : Directory Status - NOT UPLOADING";
     "body"=" WARNING : Directory $path has not had files uploaded since $date...";
    }

    $status = Invoke-WebRequest `
        -Uri "https://api.mailslurp.com/inboxes/$inboxId" `
        -Method POST `
        -Body ($params|ConvertTo-Json) `
        -ContentType "application/json" `
        -Headers @{"x-api-key"=$apiKey;} | Select-Object -Expand StatusCode
    
    Write-Output "Email sent with status $status to $recipient"    
}

# Set directory and dates
$today = Get-Date
$days_subtract = -1
$yesterday = $today.AddDays($days_subtract)
$date = 0

# Get the most recent upload datetime in the given directory
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

# Check if the most recent upload is within our time frame    
if($date -lt $yesterday){
    Write-Host "Directory $path has not had files uploaded in $($days_subtract*-1) day(s) - Most recent upload : $date"
    SendStatusEmail
}else{
    Write-Host "Directory $path is to date - Most recent upload : $date"
}
