# LogVolume
Make more accurate log volume estimations by pulling actual log volume metrics.

## MeasureLogs.ps1
For calculating log volume on Windows hosts. This script will;
* Validate Log Configuration
* Validate 7 Days of Retention
* Calculate Monthly, Weekly and Daily Log Output in MB

```
$url1 = "https://raw.githubusercontent.com/Starke427/LogVolume/main/MeasureLogs.ps1"
$file1 = "C:\MeasureLogs.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url1, $file1)
Set-ExecutionPolicy -ExecutionPolicy Bypass -force
& "C:\MeasureLogs.ps1" > LogVolumeReport.txt
```
