$software_to_remove='chrome'

if ($software_to_remove -Like 'chrome') {
        $chrome_installed_object=(Get-ItemProperty -path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome')
        if ($chrome_installed_object -ne $null) {
            $chrome_version=($chrome_installed_object | select-object -ExpandProperty Version)
            $chrome_uninstaller_string=($chrome_installed_object | Select-Object -ExpandProperty UninstallString)
            $chrome_uninstaller_full_string=($chrome_uninstaller_string+" --force-uninstall")
            Write-Host "Found the following version of Chrome: $chrome_version"
            Write-Host "Removing version $chrome_version"
            Write-Host "This is the Chrome uninstall string we are using: $chrome_uninstaller_full_string"
            cmd.exe /c $chrome_uninstaller_full_string 
            }
        }

Write-Host ("Looking for a package matching this pattern: "+$software_to_remove)

$program_to_remove = $(Get-WmiObject -Class Win32_Product | Where-Object -Property Name -Like "*$software_to_remove*")
if (![string]::IsNullOrWhiteSpace($program_to_remove)) {
    Write-Host ("These programs have been located:"+$program_to_remove)
    $program_to_remove.Uninstall()        
    }


#Look at installed packages
$PackageToRemove=$(Get-Package -Provider Programs -IncludeWindowsInstaller | Where-Object -Property Name -Like "*$software_to_remove*")
$PackageToRemove_name=$(Get-Package -Provider Programs -IncludeWindowsInstaller | Where-Object -Property Name -Like "*$software_to_remove*" | Select-Object -ExpandProperty Name)
if (![string]::IsNullOrWhiteSpace($PackageToRemove)) {    
    Write-Host "$PackageToRemove_name"
    Uninstall-Package -Name $PackageToRemove -Verbose -Force
}

#Just in case the previous approach did not remove the package successfully, use the GUID this time
Get-Package -Provider Programs -IncludeWindowsInstaller | Where-Object -Property Name -Like "*$software_to_remove*" | Uninstall-Package



#Check again, just to make sure

$x86Path = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$installedItemsX86 = Get-ItemProperty -Path $x86Path | Select-Object -Property PSChildName, DisplayName, DisplayVersion

$x64Path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
$installedItemsX64 = Get-ItemProperty -Path $x64Path | Select-Object -Property PSChildName, DisplayName, DisplayVersion

$installedItems = $installedItemsX86 + $installedItemsX64
$installedItems | Where-Object -FilterScript { $null -ne $_.DisplayName } | Sort-Object -Property DisplayName | ft

 
