#
# xWaitForJenkinsService: DSC Resource that will wait for Jenkins service to start.
#

#
# The Get-TargetResource cmdlet.
#
function Get-TargetResource
{
    param
    (	
        [parameter(Mandatory)]
		[Uint32] $JenkinsConnectionPort,

		[parameter(Mandatory)]
        [Uint32] $RetryCount,
		
        [parameter(Mandatory)]
		[Uint32] $RetryIntervalSec
    )

    @{
        JenkinsServiceName = "Jenkins"        
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
		[Uint32] $JenkinsConnectionPort,

		[parameter(Mandatory)]
        [Uint32] $RetryCount,
		
        [parameter(Mandatory)]
		[Uint32] $RetryIntervalSec
    )    

	$JenkinsRunning = $false
    $url =  [System.String]::Format("http://localhost:{0}", $JenkinsConnectionPort)
    for ($count = 0; $count -lt $RetryCount; $count++)
	{
        Write-Verbose "Inside wait for Jenkins service and portal"
        $JenkinsRunning = Check-JenkinsService
        $JenkinsWebAccessible = Ping-JenkinsWeb -url $url
		if($JenkinsWebAccessible -and $JenkinsRunning)
        {
            $JenkinsRunning = $true
            break
        }
		Write-Verbose -Message "Waiting for Jenkins service and portal to start. Will retry again after $RetryIntervalSec sec"
		Start-Sleep -Seconds $RetryIntervalSec
	}
	
	if (!$JenkinsRunning)
    {
        throw "Jenkins service\portal not running after $count attempts with $RetryIntervalSec sec interval"
    }
}

# 
# Test-TargetResource
#
function Test-TargetResource  
{
    param
    (	
       [parameter(Mandatory)]
		[Uint32] $JenkinsConnectionPort,

		[parameter(Mandatory)]
        [Uint32] $RetryCount,
		
        [parameter(Mandatory)]
		[Uint32] $RetryIntervalSec
    )

    # Set-TargetResource is idempotent.. return false
    return $false
}

function Check-JenkinsService
{
    $service =  Get-Service | Where { $_.Name -eq "Jenkins" }
    if(!$service)
    {
        return $false
    }
	if($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running)
	{
       return $true
	}
    return $false
}

function Ping-JenkinsWeb
{
    param
    (
        [string]$url
    )
    Write-Verbose "Inside Ping-Jenkins $url"
    try
    {        
        $request = [System.Net.WebRequest]::Create($url)
        $request.Method = "GET"
        $response = $request.GetResponse()
        Write-Verbose "Ping-Jenkins -- Got response -- $resonse.StatusCode"
        if($resonse.StatusCode  -eq [System.Net.HttpStatusCode]::OK)
        {
            return $true
        }
    }
    catch
    {
        return $false
    }
    return $false
}