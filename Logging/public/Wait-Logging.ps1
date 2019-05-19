<#
    .SYNOPSIS
        Wait for the message queue to be emptied

    .DESCRIPTION
        This function can be used to block the execution of a script waiting for the message queue to be emptied

    .EXAMPLE
        PS C:\> Wait-Logging

    .LINK
        https://logging.readthedocs.io/en/latest/functions/Wait-Logging.md

    .LINK
        https://github.com/EsOsO/Logging/blob/master/Logging/public/Wait-Logging.ps1
#>
function Wait-Logging {
    [CmdletBinding(HelpUri='https://logging.readthedocs.io/en/latest/functions/Wait-Logging.md')]
    param()

    #This variable is initiated inside Start-LoggingManager
    if (!(Get-Variable -Name "LoggingEventQueue" -ErrorAction Ignore)) {
        return
    }

    $start = [datetime]::Now

    while ($Script:LoggingEventQueue.Count -gt 0) {
        Start-Sleep -Milliseconds 10

        <#
        If errors occure in the consumption of the logging requests,
        forefully shutdown function after some time.
        #>
        $difference = [datetime]::Now - $start
        if ($difference.Minutes -gt 5) {
            Write-Error -Message ("{0} :: Wait timeout.") -ErrorAction SilentlyContinue
            break;
        }
    }
}
