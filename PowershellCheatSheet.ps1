<#

.Synopsis

My list of Powershell notes and advice

.Description

Use with comments and actual script to show use and tips and trick

Created by Tim Gibney

#>

#Environment Path
	PS C:> cd env:
	PS Env:> ls path
#And out comes the entry for the path variable
	NAME                         VALUE
	——                          ——-
	Path                          C:\windows\system32;C:\;C:\Sysinternals…
#The path environment variable has 2 properties:
	KEY
	VALUE
#You see here that “Name” is actually an alias for “Key”.
	PS Env:\> ls path | gm
	TypeName: System.Collections.DictionaryEntry
	Name          MemberType    Definition
	—-          ———-    ———-
	Name          AliasProperty Name = Key
	…
	(other methods and noteproperties)
	…
	Key           Property      System.Object Key {get;set;}
	Value         Property      System.Object Value {get;set;}
#If you want to see the actual value (what the path is), try this:
	PS Env:> (ls path).value
#If you want to see the individual lines in the path:
	PS Env:> (ls path).value.split(“;”)
#How many characters are in YOUR entire path statement?  Find out!
	PS Env:> (ls path).value.length
#How many entries are in your path statement?
	PS Env:> ((ls path).value.split(“;”) | measure).count
	Just list the entries in the path that are in the windows directory and below:
	(ls path).value.split(“;”) | ? {$_ -like “C:\Windows*” -or $_ -like “%systemroot%*”}

#PowerShell on Ubuntu linux
(Get-Host).Version
# Update the list of packages
sudo apt-get update
# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common
# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Update the list of products
sudo apt-get update
# Enable the "universe" repositories
sudo add-apt-repository universe
# Install PowerShell
sudo apt-get install -y powershell
# Start PowerShell
pwsh
$profile
#open $profile in VS Code
Code $profile
#Create a new alias in $profile once open
New-Alias "md" "mkdir"

#Execute non-powershell executable if safe
	Use the .\<executable name>
		Sysinternals psexec
			.\psexec

#Environment variables
	Change directory to Environment
		cd env:
		List path
			ls path
	Path
		$Env:Path
	Capture current path in $CurrentPath
		[string]$CurrentPath = $Env:Path
	Add C:\MyPath to beginning of path
		$Env:Path = "C:\MyPath;$Env:Path"
	Add C:\MyPath to end of path
		$Env:Path += ";C:\MyPath"
		
#Powershell variables
	List all powershell variables
		Get-Variable | Out-String
	Create variable
		[string]$<variable name>="some string"
	List variable contents
		$<variable name>

#Drive space
df #linux
Get-PSDrive
free #linux
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5

#Quick CPU test
$a = 1..20000
Measure-Command {Write-Output $a | Out-Default}
	
#Manage local groups remotely with Sysinternals PsExec
	List local administrators' group members
		psexec \\<computer name> net localgroup "administrators"
	Add AD user to local Power Users' group
		psexec \\<computer name> net localgroup "Power Users" "<domain>\<username>" /add
	Delete AD user from local Administrators' group
		psexec \\<computer name> net localgroup administrators "<domain>\<username>" /delete
		
#CSV files
	Import csv file
		$<variable name> = import-csv .\<filename>.<fileextension> (imports from current directory
			PS C:\Software\PowerShell> $testcsv = import-csv .\MoveAdministratorsToPowerUsers.txt		create $testcsv variable with file's contents
			PS C:\Software\PowerShell> $testcsv			list variable contents

			ComputerName Username
			------------ --------
			KAUN1768     tgibney
			KAUN1768     lisal
			KAUN1768     billr


			PS C:\Software\PowerShell> foreach($record in $testcsv)			Build foreach using records from $testcsv foreach(variable in pipeline){statements}
			>> {
			>> $ComputerName = $record.ComputerName			variable = pipeline.columnname
			>> $UserName = $record.UserName
			>>
			>> Echo "$ComputerName, $UserName"			return records without headers
			>> }
			KAUN1768, tgibney
			KAUN1768, lisal
			KAUN1768, billr

#Clears file's contents
	Clear-Content C:\My\Directory\MyFile.extension			
			
#Capture output
	Set output variable equal to the command being processes
		$Results = foreach($i in 1..5){$i}
			
#Output
	Variable | Out-File C:\File\Path\FileName.Extension
	
	Write-Information "Some information" 6>> C:\My\Directory\myfile.extension
#Execution Policy - run in dir where active
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
#Test network connection
	Test-Connection -Count 1 <computername> -Quiet			returns "True" if connected
	
#Active Directory
	Get-Module -Name ActiveDirectory
	Get-Module -Name ActiveDirectory -ListAvailable
	Import-Module -Name ActiveDirectory
	Get-Command -Module ActiveDirectory -Name *OrganizationalUnit*
	
#Get-OdbcDSN 
	get-odbcdsn | select-object -property Name, Platform
#And all propertyvalues
	PS C:\windows\system32> $TheDSN=get-odbcdsn -name "TablesCoE_64bit"
	PS C:\windows\system32> $TheDSN.PropertyValue
	Server=NTSQL
	Database=TablesCoE
	Encrypt=No
	TrustServerCertificate=No
	ClientCertificate=
	KeystoreAuthentication=
	KeystorePrincipalId=
	KeystoreSecret=
	KeystoreLocation=
	Trusted_Connection=Yes
#Hide headers
	Get-OdbcDsn | Select-Object Name | Format-Table -HideTableHeaders -Autosize
#Output to file
	Get-OdbcDsn | Select-Object Name | Out-File -FilePath Get-ODBC_DSNs20201007115327KAUN1662.txt
#Block comment
	<#
	Some comment
	block
	#>
#Comment
	#Commented text
#Remote Session
	Enter-PSSession -ComputerName "KAUN1662"
#Invoke command on remote PC
	Invoke-Command -ComputerName "KAUN1662" -Scriptblock { Get-OdbcDsn | Select-Object Name }
#Computer lists
	$KalwallKPRComputers = "KAUN1733","KAUN1788","KWCD1614","KWCD1615","KWCD1618","KWCD1619","KWCD1633","KWCD1804","KWCD1827","KWCD1858","KWCD1863","KWCD1866","KWCD1867","KWCD1881","KWVP1632"

#Create Scriptblock
	$sbGetODBC_DSNs={
    $Computers = "KAUN1788","KAUN1662","KAUN1726","KAUN1773","KAUN1792","KAUN1799","KAUN1846","KAUN1886","KAUN1892","KAUN1895","KWCD1615","KWCD1866","SUI1663","SUI1789"
    $TheDateAndTime = Get-Date -Format "yyyyMMddHHmmss"
    $FileNameHeader = "Get-ODBC_DSNs"
    $FileNameExtension = ".txt"
    $TheFilePath = -Join($FileNameHeader,$TheDateAndTime,$FileNameExtension)
    Set-Content -Path $TheFilePath -Value $TheDateAndTime
    ForEach ($Computer in $Computers){
        $ODBCDSNs = Invoke-Command -ComputerName $Computer -Scriptblock { Get-OdbcDsn | Select-Object Name | Format-Table -HideTableHeaders -Autosize }
        $Computer | Out-File -FilePath $TheFilePath -Encoding ASCII -Append		#-Encoding ASCII stopped NULs from every other character
        $ODBCDSNs | Out-File -FilePath $TheFilePath -Encoding ASCII -Append		#-Append is required here instead of -NoClobber
		} 
	}
#Run ScriptBlock
	&$sbGetODBCDSNs
#Windows Remoting
	Enable-PSRemoting or winrm quickconfig
#Common Information Model CIM
	Get-ODBCDSN -Cimsession KAUN1895 | select name
#Get-OdbcDsn and show parameters
	Get-ODBCDSN | Select Name, @{n='Description';e={$_.Attribute.Description}}, @{n='Server Name';e={$_.Attribute.Server}}
#Get-OdbcDsn using Where-Object
	Get-ODBCDSN | Where-Object{ ($_.Attribute["Server"] -eq "RRKSQL") } | Select-Object Name, @{Name='Description';Expression={$_.Attribute.Description}}, @{n='Server Name';e={$_.Attribute.Server}}, @{n='Database';e={$_.Attribute.Database}}
#List all object properties
	Get-OdbcDsn | Where-Object Name -eq "TablesCoE" | Select-Object -Property *
#Use Show-Object to get all class objects in a GUI
	Get-OdbcDsn | Where-Object Name -eq "LocalKalwallShipping" | show-Object
#Line continuation - use a <space> ` <Enter>--------------------------------------------------------------------------------------------vvv
	Get-OdbcDsn | Select Name, DsnType, Platform, @{n='Server Name';e={$_.Attribute.Server}}, @{n='Database';e={$_.Attribute.Database}} `
  , @{n='Description';e={$_.Attribute.Description}} | Format-Table -AutoSize | Out-File -FilePath $TranscriptFile -Encoding ASCII -Append
#Version
	Get-Host | Select-Object Version
	$PSVersionTable
#Upgrade Git
	Git Update-Git-For-Windows
#Repository initialization
	#Create repo on Github.com/mctimoth
		#If README.md, .gitignore, javascript, and html files already exist just create the repo
		#otherwise create the repo with the README.md, .gitignore and licenses
	#Create local directory for repository and CD into that directory
	#Create a file in that directory so it is not empty
		echo "# Some differentiating text for the repository specific file" >> README.md
	#initialize the repo
		git init
	#add first file to the repo
		git add README.md
	#commit first file to repo
		git commit -am "first commit"
	#Make first branch
		git branch -M main
	#add web location origin using the github URL to the repo created above
		git remote add origin https://github.com/mctimoth/<new repository>.git
	#do first push from local repo to github
		git push -u origin main
	#sync local repo from github repo
		git pull
	#add one file
		git add <filename with directory structure from pwd>
	#add all files
		git add .
	#commit all adds
		git commit -am "Some descriptive text"
	#check status of repo
		git status
		git show
		git remote show
		git remote show origin
		git config --get remote.origin.url #or
		git remote get-url origin
		git config -l
	#clone from github Internt repo - cd to local working directory first
		git clone

#Install bootstrap - done on a pre-project basis and into the project's root directory
	npm init #makes the project an npm project - creates the package.json file
	npm i(nstall) bootstrap #adds node_modules dir - be sure to gitignore node_modules
	npm i(nstall) jquery
	#use the following link in .html files depending on dev or prod
		<link rel="stylesheet" href="node_modules/bootstrap/dist/css/bootstrap.css">
	#use the following scripts in .html files depending on dev or prod - they are order specific
		<script src="node_modules/jquery/dist/jquery.js"></script>
		<script src="node_modules/bootstrap/dist/js/bootstrap.bundle.js"></script>
#install http-server
	npm -v
	npm install -g http-server #-g is a global install
	http-server #run from root directory where index.html is located - localhost:8080 to see served pages
	#http server local use
		"loopback"=="localhost"==127.0.0.1==::1 
	#getting bootstrap version is in package.json
#node.js - Gatsby
	install node.js from https://nodejs.org/en/download/
	npm i(install) bootstrap #install on a per site (directory specific) basis
	npm i(nstall) jquery
	#npm install -g gatsby-cli 
	#gatsby telemtry --disable
	#gatsby new hello-world https://github.com/gatsbyjs/gatsby-starter-hello-world
	#gatsby new <web page name> <URL for gatsby starter>
	#gatsby develop  #starts HTTP server at localhost:8000 for whatever directory the development session is started in - Ctrl+C to end HTTP server
#mocha and chai install - node and npm install required
#install mocha and chai on a per project basis
#at the CLI browse to the project's root directory
npm init #take defaults <npm init -y> will take all the defaults automatically
npm install mocha #update gitignore to ignore the newly created node_modules/
npm install chai

# gitignore for SQL
# # -----------------------------------------------------------------
# # .gitignore for SQL Change Automation
# # -----------------------------------------------------------------

# bin/
# obj/
# /*.dbmdl
# /*.ifm
# /*.sqlproj.user

# gitignor for javascript (including mocha and chai)
# # -----------------------------------------------------------------
# # .gitignore for JavsScript (including mocha and chai)
# # -----------------------------------------------------------------
#
# ~$*.docx
# *.tmp
# node_modules/
# .~lock.*.* #OpenOffice on linux

git config --global user.email "mctimoth@gmail.com"
git config --global user.name "Tim Gibney"
# Configure git to use VSCode as merge tool
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd "code --wait $MERGED"
#VS Code settings changes
#Ctrl+, to open settings
#Files.DefaultLanguage.{activeEditorLanguage}
#Editor.Suggest.Show Status Bar - check
	#Ctrl+space
#Editor.Suggest.Insert Mode - Insert
#turn on powerMode for a LOL

#MS SQL on Ubuntu linux
	#get ubuntu version
	lsb_release -a
	#Check SQL Server status
	systemctl status mssql-server
	#stop start restart sql server
	sudo systemctl [stop|start|restart] mssql-server
	#start sqlcmd session
	sqlcmd -S localhost -U sa -P '[password]'
	#Stop and Disable mssql-server service.
	sudo systemctl stop mssql-server
	sudo systemctl disable mssql-server
	#Enable and start mssql-server service.
	sudo systemctl enable mssql-server
	sudo systemctl start mssql-server
	#install SQL Server
	sudo apt update && sudo apt upgrade
	sudo apt install mssql-server
	sudo /opt/mssql/bin/mssql-conf setup
	systemctl status mssql-server.service
	#install SQL Server Tools
	curl https://packages.microsoft.com/config/ubuntu/19.10/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
	sudo apt update
	sudo apt install mssql-tools -y
	echo ‘export PATH=”$PATH:/opt/mssql-tools/bin”‘ >> ~/.bash_profile
	echo ‘export PATH=”$PATH:/opt/mssql-tools/bin”‘ >> ~/.bashrc
	source ~/.bashrc
	#install ODBC drivers
	sudo su
	curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

	#Download appropriate package for the OS version
	#Choose only ONE of the following, corresponding to your OS version

	#Ubuntu 16.04
	curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

	#Ubuntu 18.04
	curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

	#Ubuntu 20.04
	curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

	#Ubuntu 20.10
	curl https://packages.microsoft.com/config/ubuntu/20.10/prod.list > /etc/apt/sources.list.d/mssql-release.list

	exit
	sudo apt-get update
	sudo ACCEPT_EULA=Y apt-get install msodbcsql17
	# optional: for bcp and sqlcmd
	sudo ACCEPT_EULA=Y apt-get install mssql-tools
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
	source ~/.bashrc
	# optional: for unixODBC development headers
	sudo apt-get install unixodbc-dev
