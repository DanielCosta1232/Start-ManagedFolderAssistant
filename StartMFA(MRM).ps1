<#

This script is to 'kickstart' MRM. Due to MFA running at the lowest possible priority, 
if any resource need the mailbox while MFA runs, it will stop running. Per Microsoft, the current workaround is 
to force run MRM until it completes. They are working on a backend solution but until it is rolled out, this is the recommended 'workaround' method.

Note:
You will need to reauthenticate once the script loops or you can enter credentials (it is recommended to use an account with
limited perimissions) under the '#variables' section to automate the process. If you do decide to automate the script, 
you will also need to change 'Connect-Exo' to 'AutoConnect-Exo' within the script.

This script is best used in conjunction with the MRM diag script.
https://gallery.technet.microsoft.com/office/Powershell-script-to-2489e63b

#>

# Functions

function Connect-Exo {
  Write-Host "Establishing new Exchange Online Session..."
  $credential = Get-Credential
  $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $credential -Authentication Basic -AllowRedirection
  Import-PSSession $Session -AllowClobber -DisableNameChecking
  Write-Host "`n"
}

function AutoConnect-Exo {
  Write-Host "Establishing new Exchange Online Session..."
  $username = Get-Content C:\Users\scripts\cred.txt
  $password = Get-Content C:\Users\scripts\cred1.txt | ConvertTo-SecureString -AsPlainText -Force
  $automate = New-Object -Typename System.Management.Automation.PSCredential -Argumentlist $username, $password
  $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $automate -Authentication Basic -AllowRedirection
  Import-PSSession $Session -AllowClobber -DisableNameChecking
  Write-Host "`n"
}
  
function RunMRM {
  Write-Host "Running Start MFA..."
  Start-ManagedFolderAssistant -Identity $user -ErrorAction SilentlyContinue
  Write-Host "Done. MRM start request executed."
  Write-Host "`n"
}

function RemoveSession {
  Write-Host "Removing all active sessions..."
  Get-PSSession | Remove-PSSession
}

function Sleep15 {
  Write-Host "Sleeping for 15 minutes..."
  Start-Sleep -s 900
}

function ScriptCancelMessage {
  Write-Host "`n"
  Write-Host "To stop this script at anytime, use Ctrl + C" -ForegroundColor Red 
  Write-Host "`n"
}

# Script starts here
$WindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$WindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($WindowsID)
$AdminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if ($WindowsPrincipal.IsInRole($AdminRole)) {
    $user = Read-Host "Please enter the user's email address."
    $i = 0
        while ($i -lt 1000) {
          ScriptCancelMessage
          Connect-Exo
	        ## Once steps above are completed, change 'Connect-Exo' to 'AutoConnect-Exo' to automate the script. Running it 'as is' will work, but credentials will need to be entered every loop.
          RunMRM
          RemoveSession
          Sleep15
          Write-Host "This script has attempted to run MRM $i times."
          $i++
          Clear
        }
        else {
          Write-Host "This script has completed."
        }
    }
else {
    Write-Host "`nPlease run this script in an elevated PowerShell window."
}