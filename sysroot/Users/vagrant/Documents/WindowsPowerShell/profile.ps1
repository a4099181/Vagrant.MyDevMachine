$InformationPreference= 'Continue'

Get-ChildItem $env:USERPROFILE\.docker -Filter "*.ps1" | % { . $_.FullName }

if ( Test-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\" )
{
        Get-ChildItem "${env:ProgramFiles(x86)}\Microsoft Visual Studio\" -Recurse -Include msbuild.exe, devenv.exe |
            Group-Object -Property Name |
            ForEach-Object { Set-Alias -Verbose -Name $_.Name[2].ToString().ToLower() -Value "$($_.Group[0].FullName)" }
}

Get-Command docker, explorer, git, kubectl |
    ForEach-Object { Set-Alias -Verbose -Name $_.Name[0] -Value ( $_.Name -replace "$($_.Extension)$", "" ) }

function Update-SysRoot {
    Get-ChildItem -Recurse C:\vagrant\sysroot\ -File |
    Select-Object @{N='local';E={[System.IO.FileInfo]::new(($_.FullName -replace 'C:\\vagrant\\sysroot\\', 'C:\'))}},@{N='remote';E={$_}} |
    Where-Object { $_.local.LastWriteTimeUtc -gt $_.remote.LastWriteTimeUtc } |
    ForEach-Object {
        Copy-Item -path $_.local.FullName -Destination $_.remote.FullName -Verbose
    }
}

function Clear-TestDatabases
{
    sqllocaldb info |
        ForEach-Object {
            $i = $_;
            sqlcmd -S "(localdb)\$i" -E -h-1 -Q "SET NOCOUNT ON; SELECT name FROM sysdatabases" |
            Where-Object { $_ -like 'nunit_*' } |
            ForEach-Object {
                Write-Warning -Message $_
                sqlcmd -S "(localdb)\$i" -E -h-1 -Q "DROP DATABASE $_;"
            }
        }
}

function Get-FreeDiskSpace
{
    param (
        [string] $driveName = "C",
        [int] $yellowThreshold = 15,
        [int] $orangeThreshold = 10,
        [int] $redThreshold = 5
    )

    $drive = Get-PSDrive -Name $driveName
    $free = 100 * $drive.Free / ($drive.Used + $drive.Free)

    if ($free -lt $redThreshold) {
        @{
          "Light"= [ConsoleColor]::Red;
          "Free" = $drive.Free
        }
      }
    elseif ($free -lt $orangeThreshold) {
        @{
          "Light"= [ConsoleColor]::Yellow;
          "Free" = $drive.Free
        }
      }
    elseif ($free -lt $yellowThreshold) {
        @{
            "Light"= [ConsoleColor]::Gray;
            "Free" = $drive.Free
        }
    }
}

function Write-Tips
{
    Write-Information "WinRM tip: (<IP>) | % { Set-Item WSMan:\localhost\Client\TrustedHosts -Concatenate -Value `$_ }"
}

if ( ( Get-Command kubectl ) )
{
    function Switch-K8sNamespace
    {
        Param(
            [Parameter(Mandatory=$true)]
            [ValidateSet('ci-soneta', 'default', 'kube-system', 'test-soneta')]
            [String]
            $namespace
        )

        & ( Get-Command kubectl ).Source config set-context --current --namespace $($namespace)

        ( ( & ( Get-Command kubectl ).Source config view -o json) | ConvertFrom-Json).contexts[0].context
    }

    if (Get-Command code -ErrorAction SilentlyContinue)
    {
        $env:KUBE_EDITOR='code -w'
    }

    Set-Alias -Verbose -Name sn -Value Switch-K8sNamespace

        if ( (Get-Command ssh) -And ( -Not ( Test-Path ~\.kube\config ) ) )
        {
            New-Item ~\.kube -Verbose -ItemType Directory -Force | Out-Null
            ssh vagrant@master-vh1 cat ~/.kube/config | Set-Content -Verbose -Path ~/.kube/config
        }

        $__k8sPromptScriptBlock = {
        Write-Host (Get-Date).ToUniversalTime().ToString("HH:mm.ssZ") -Foreground Cyan -NoNewLine
        Write-Host " [" -Foreground Yellow -NoNewLine
        Write-Host "k8s: " -Foreground DarkGray -NoNewLine
        Write-Host (( & ( Get-Command kubectl ).Source config view -o json) | ConvertFrom-Json | select -ExpandProperty contexts -first 1).context.namespace -Foreground Gray -NoNewLine
        Write-Host "] " -Foreground Yellow -NoNewLine

        $free = Get-FreeDiskSpace
        if ($free.Light -in ( [ConsoleColor]::Gray, [ConsoleColor]::Red, [ConsoleColor]::Yellow ))
        {
            Write-Host "[" -Foreground Yellow -NoNewLine
            Write-Host "$(($free.Free / 1gb).ToString('n1'))GB" -Foreground $free.Light -NoNewLine
            Write-Host "] " -Foreground Yellow -NoNewLine
        }

        if ( $GitPromptScriptBlock )
        {
            Invoke-Command -ScriptBlock $GitPromptScriptBlock
        }
    }

    Set-Item Function:\prompt -Value $__k8sPromptScriptBlock

    Import-Module PSKubectlCompletion
}

Import-Module MyTasks
Set-MyTaskHome -Path 'C:\Users\vagrant\OneDrive - Soneta sp. z o.o\.tasks'
Get-MyTask