#
# xJenkinsPlugins: DSC resource to configure Jenkins.
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
        [string] $JenkinsPath
    )

    $service =  Get-Service | Where { $_.Name -eq "Jenkins" }
    if($service -and ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running))
    {
        return $true
    }
    return $false
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
        [string] $JenkinsPath
    )       

    $JavaPath =  "$JenkinsPath" + "\jre\bin\java"
    $JenkinsCliJar =  "$JenkinsPath" + "\jenkins-cli.jar"
    $JenkinsPluginsFolder =  "$JenkinsPath" + "\plugins"

    $InstalledPlugins = & "$JavaPath" -jar "$JenkinsCliJar" -s http://localhost:8080/ list-plugins

    $webClient = New-Object System.Net.WebClient

    $msbuildHpiPath =  "$JenkinsPluginsFolder" + "\msbuild.hpi"
    Write-Verbose "Started downloading plugins"
    Write-Verbose "Msbuild hpi path: $msbuildHpiPath"
    if(-Not (JenkinsPluginExists $InstalledPlugins "msbuild")) {
        Write-Verbose "Downloading msbuild plugin..."
        $webClient.DownloadFile("http://updates.jenkins-ci.org/latest/msbuild.hpi", $msbuildHpiPath)
        Write-Verbose "Successfully downloaded msbuild plugin."
    }

    $nunitHpiPath =  "$JenkinsPluginsFolder" + "\nunit.hpi"
    Write-Verbose "Nunit hpi path: $nunitHpiPath"
    if(-Not (JenkinsPluginExists $InstalledPlugins "nunit")) {
        Write-Verbose "Downloading nunit plugin..."
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile("http://updates.jenkins-ci.org/latest/nunit.hpi", $nunitHpiPath)
        Write-Verbose "Successfully downloaded nunit plugin."
    }        

    $gitClientHpiPath = "$JenkinsPluginsFolder" + "\git-client.hpi"
    Write-Verbose "Git Client hpi path: $gitClientHpiPath"
    if(-Not (JenkinsPluginExists $InstalledPlugins "git-client")){
        $webClient.DownloadFile("http://updates.jenkins-ci.org/latest/git-client.hpi", $gitClientHpiPath)
        Write-Verbose "Successfully downloaded git-client plugin."
    } 

    $gitServerHpiPath = "$JenkinsPluginsFolder" + "\git-server.hpi"
    Write-Verbose "Git server hpi path: $gitServerHpiPath"
    if(-Not (JenkinsPluginExists $InstalledPlugins "git-server")) {
        Write-Verbose "Downloading git-server plugin..."         
        $webClient.DownloadFile("http://updates.jenkins-ci.org/latest/git-server.hpi", $gitServerHpiPath)
        Write-Verbose "Successfully downloaded git-server plugin."    
    }

    $scmapiHpiPath = "$JenkinsPluginsFolder" + "\scm-api.hpi"
    Write-Verbose "scm api hpi path: $scmapiHpiPath"
    if(-Not (JenkinsPluginExists $InstalledPlugins "scm-api")) {
        Write-Verbose "Downloading scm-api plugin..."         
        $webClient.DownloadFile("http://updates.jenkins-ci.org/latest/scm-api.hpi", $scmapiHpiPath)
        Write-Verbose "Successfully downloaded scm-api plugin."
    }

    $gitHpiPath = "$JenkinsPluginsFolder" + "\git.hpi"
    Write-Verbose "Github hpi path: $gitHpiPath"
    if(-Not (JenkinsPluginExists $InstalledPlugins "git")) {
        Write-Verbose "Downloading git plugin..."
        $webClient.DownloadFile("http://updates.jenkins-ci.org/latest/git.hpi", $gitHpiPath)
        Write-Verbose "Successfully downloaded git plugin."
    }

    Write-Verbose "Plugins downloaded successfully."    
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
        [string] $JenkinsPath
    )

    return $false   
}

function JenkinsPluginExists {
    param([string[]]$InstalledPlugins,
          [string]$PluginId)    

    $InstalledPlugins | ForEach-Object { if($_.Contains($PluginId)) { return $true } }
    return $false
}