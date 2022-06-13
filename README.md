### StartManagedFolderAssistant.ps1

This script is to 'kickstart' MRM. Due to MFA running at the lowest possible priority, 
if any resource need the mailbox while MFA runs, it will stop running. Per Microsoft, the current workaround is 
to force run MRM until it completes. They are working on a backend solution but until it is rolled out, this is the recommended 'workaround' method.
Note:
You will need to reauthenticate once the script loops or you can enter credentials (it is recommended to use an account with
limited perimissions) under the '#variables' section to automate the process. If you do decide to automate the script, 
you will also need to change 'Connect-Exo' to 'AutoConnect-Exo' within the script.

This script will attempt to run MFA once every 15 minutes for the user specified. This is usually used in extreme cases where MFA has not processed in months and a mailbox has reached 50+ GBs in size. (Exchange online has an 100GB mailbox limit.)

This method is usually used in conjunction with the [MRM diagnostic script](https://gallery.technet.microsoft.com/office/Powershell-script-to-2489e63b)
