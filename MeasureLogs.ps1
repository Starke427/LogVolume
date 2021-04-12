# Get Windows Log Volume Metrics
#
# Author: Jeff Starke (Starke427)
# Version: 1.0
# Updated: 04/12/2021

# Log Sources
$logList = "Application","Security","System","*PowerShell*","*SSH*","*WinRM*","*WMI*","*RDPClient*","*TaskScheduler/Operational*","*SmbClient/Operational*","*BitLocker*","*AppLocker*","*Sysmon*"

################################ Validate Log List ########################################
echo "######################"
echo "Validating availability of event logs..."
Get-winevent -ListLog $logList
echo "######################"
echo ""

########################### Validation of Log History ######################################
echo "Validating that there are at least 7 days of available logs"
echo "by checking for logs older than $((Get-Date).AddDays(-7))..."
echo ""
echo "Any log sources without timestamps either have"
echo "insufficient storage for seven days of log retention"
echo "or their oldest log is older than 30 days."
echo ""
function Check-RecentLog($logSource){
  Get-WinEvent -FilterHashtable @{
    Logname=$logSource
    StartTime=$(Get-Date).AddDays(-30)
    EndTime=$(Get-Date).AddDays(-7)
    } -EA SilentlyContinue  | Select-Object -First 1 -Property LogName, TimeCreated
}
echo "######################"
ForEach ($logSource in $logList){
    Check-RecentLog -logSource $logSource
}
echo "######################"
echo ""

####################### Calculate Consumption based on Most Recent 7 Days ##########################
echo "Measuring the volume of logs based on the past seven days..."
echo "This may be lower than actual consumption if a particular"
echo "log source does not have more than seven days of available logs,"
echo "as indicated by the previous section."
echo ""
echo "This may take up to 20 minutes to complete."
echo ""
function Measure-RecentLogs($logSource){
  echo "######################"
  echo "$logSource Logs"
  $logCount=((Get-WinEvent -FilterHashtable @{
    Logname=$logSource
    StartTime=(Get-Date).AddDays(-7)
  } -EA SilentlyContinue  | Measure-Object).count*700/1000000)
  echo "$(($logcount/7)*30)MB/month"
  echo "$($logCount)MB/week"
  echo "$($logcount/7)MB/day"
  echo "######################"
  echo ""
}
ForEach ($logSource in $logList){
  Measure-RecentLogs -logSource $logSource
}
