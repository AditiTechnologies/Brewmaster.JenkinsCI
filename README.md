###Overview
Using the latest image of Windows Server 2012, it will install and configure the latest [Jenkins server](https://jenkins-ci.org/) for Windows.

###Virtual Machine (VM)
One VM will be created with a dedicated data disk for storing Jenkins data. The web portal for Jenkins will be configured to be accessible on port 80

###Jenkins Details
1.	Jenkins server is installed as a windows service running on the local system account.
2.	Web Portal - `http://<JenkinsCloudService>.cloudapp.net:<80>`

###Installation

This template auto installs the following on the virtual machine:

**Jenkins Plugins**

1.	**MsBuild** - This plugin allows you to use MSBuild to build .NET projects.
2.	**Git** - This plugin allows use of Git as a build SCM.
3.	**Git-Client** - This plugin provides an API to execute general-purpose git operations on a local or remote repository.
4.	**Git-Server** - This plugin wraps the server-side functionality of JGit so that other plugins can easily expose Git repositories from Jenkins via its SSH transport and HTTP in a collaborative fashion.

**Microsoft Azure SDK** 

The template auto installs Microsoft Azure SDK for cloud deployments.

###Limitations
1. The template does not configure security for jenkins. As soon as the template completes execution, access the Jenkins web portal immediately to setup the security. Refer [Jenkins security setup](https://wiki.jenkins-ci.org/display/JENKINS/Standard+Security+Setup) for more details.
2. The template does **not configure SSL** for jenkins portal, in case SSL is required this should be done manually on the virtual machine once the deployment completes.

###References
Please refer to the following links for more information on Jenkins installation and configuration.
> - [Installing and Configuring Jenkins Server](https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+as+a+Windows+service#InstallingJenkinsasaWindowsservice-InstallJenkinsasaWindowsservice)
> - [Setting up Security](https://wiki.jenkins-ci.org/display/JENKINS/Standard+Security+Setup)