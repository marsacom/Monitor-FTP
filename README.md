# Monitor-FTP

A simgple powershell script, designed to be set as a scheduled task for monitoring a directory for upload times and alert through email if files have not been uploaded in a set amount of time.

The script is designed to be used for monitoring a directory where files are being uploaded through FTP
to verify files are being uploaded on a day to day basis but can be used for any directory where files are being uploaded  
and with some minor customization and tweaks you can get this working for your specific use case.

This script uses **MailSlurp** and their email API for sending emails. This is because the previous preferred cmdlet for sending emails 
through powershell **(Send-MailMessage)** is no longer supported and does not allow for secure connection. 

> Be sure to change the necessary variables in ***monitor.ps1***

## Installation & Setup

Step 1. ***Clone The Repository*** 
- ``git clone https://github.com/marsacom/Monitor-FTP.git``

Step 2. ***Register & Setup MailSlurp Account***

Step 3. ***Open a Powershell terminal and set your APIKEY ENV***
- ``$Env:$MAIL_API_KEY = "YOUR-KEY-HERE"``

Step 4. ***Set Necessary Variables***
- ``In monitorftp.ps1 change the $PATH & $RECIPIENT variables``

Step 5. ***Set Up Scheduled Task***
- ``If you need assistance refer to the following tutorial``
    - https://o365reports.com/2019/08/02/schedule-powershell-script-task-scheduler/

## Notes
Author : Brayden Kukla - 2024
