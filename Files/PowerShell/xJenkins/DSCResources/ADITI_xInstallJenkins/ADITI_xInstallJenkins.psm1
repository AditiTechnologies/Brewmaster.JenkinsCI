#
# xInstallJenkins: DSC resource to install Jenkins.
#

#
# The Get-TargetResource cmdlet.
#
function Get-TargetResource
{
	param
	(	
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $JenkinsDirectory,
		
		[parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $JenkinsZipPath,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $JenkinsSetupExtractPath
  	)
    
    $retVal = @{ 
       JenkinsService = $s =  Get-Service | Where { $_.Name -eq "Jenkins" }; 
       JenkinsDataDirectory = "$JenkinsDirectory";
    }
}

#
# The Set-TargetResource cmdlet.
#
function Set-TargetResource
{
	param
	(	
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $JenkinsDirectory,
		
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $JenkinsZipPath,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $JenkinsSetupExtractPath
  	)
   
    $JenkinsZipFile =  Get-ChildItem "$JenkinsZipPath" -Filter "jenkins.zip"
          
    $env:Path += ";${env:ProgramFiles(x86)}\7-zip"
	7z x $($JenkinsZipFile.FullName) -o"$JenkinsSetupExtractPath"
    
    [Environment]::SetEnvironmentVariable("JENKINS_HOME", $JenkinsDirectory, "Machine")
	$JenkinsWindowsInstaller = Get-ChildItem "$JenkinsSetupExtractPath" -include *.msi -Recurse
	$MsiexecPath = "$env:windir" + "\System32" + "\msiexec"
    $JenkinsIntallLogPath = "$JenkinsDirectory" + "\jenkins-install-log.txt"
   
    Write-Verbose "Installing Jenkins"
    Write-Verbose "Installation log file path $JenkinsIntallLogPath"
	& $MsiexecPath /I "$JenkinsWindowsInstaller" JENKINSDIR="$JenkinsDirectory" /L*V  "$JenkinsIntallLogPath" /qn    
}

#
# The Test-TargetResource cmdlet.
#
function Test-TargetResource
{
	param
	(	
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $JenkinsDirectory,
		
		[parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $JenkinsZipPath,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $JenkinsSetupExtractPath
  	)
    
    $service =  Get-Service | Where { $_.Name -eq "Jenkins" }
	if($service -and ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running))
	{
		return $true
	}
	return $false
}

Export-ModuleMember -Function *-TargetResource