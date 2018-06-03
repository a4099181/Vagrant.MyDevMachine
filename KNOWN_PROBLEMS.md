### Known problems

```
==> vs2017: Running provisioner: shell...
    vs2017: Running: script: Copy-GitRepositories C:\Users\vagrant\cfg.json .vagrant\my-private.key
    vs2017:     Directory: C:\Users\vagrant
    vs2017: Mode                LastWriteTime         Length Name
    vs2017: ----                -------------         ------ ----
    vs2017: d-----       24.11.2018     11:05                MyProjects
    vs2017: Warning: Permanently added the RSA host key for IP address '140.82.118.3' to the list of known hosts.
    vs2017: fatal: destination path 'enova' already exists and is not an empty directory.
    vs2017: fatal: destination path 'generator' already exists and is not an empty directory.
```

> Can be ignored. Git commands needs a review.

```
==> vs2017: Running provisioner: shell...
    vs2017: Running: script: ("meslolg.dz") | ?{@(Get-Package $_ -ErrorAction Ignore).Count -eq 0} | %{Install-Package $_ -Force}
    vs2017: WARNING: Unable to download from URI 'https://github.com/downloads/andreberg/Meslo-Font/Meslo LG DZ v1.0.zip' to ''.
    vs2017: Install-Package : The archive file type is not supported.
    vs2017: At C:\tmp\vagrant-shell.ps1:1 char:89
    vs2017: + ...  $_ -ErrorAction Ignore).Count -eq 0} | %{Install-Package $_ -Force};
    vs2017: +                                               ~~~~~~~~~~~~~~~~~~~~~~~~~
    vs2017:     + CategoryInfo          : NotImplemented: (C:\Users\vagran...tey\install.zip:String) [Install-Package], Exception
    vs2017:     + FullyQualifiedErrorId : UnsupportedArchive,Microsoft.PowerShell.PackageManagement.Cmdlets.InstallPackage
```

> MESLO LG.DZ font is marked as broken in the chocolatey ...

```
==> vs2017: Running provisioner: shell...
    vs2017: Running: script: Install-VisualStudio2017Extensions C:\Users\vagrant\cfg.json
    vs2017: C:\Users\vagrant\AppData\Local\Temp\enovaMSDN.SonetaStudioExtPackage.vsix
    vs2017: powershell.exe : Invoke-WebRequest : {"$id":"1","innerException":null,"message":"Anonymous usage from IP address 178
    vs2017:     + CategoryInfo          : NotSpecified: (Invoke-WebReque... IP address 178:String) [], RemoteException
    vs2017:     + FullyQualifiedErrorId : NativeCommandError
    vs2017: .19.100.140 has exceeded our rate limits and is being blocked. Anonymous access from this IP addres
    vs2017: s will be unblocked within the next 1 minute. You can also consider logging in to get unblocked. Lo
    vs2017: gged in users have higher limits. Learn more: https://go.microsoft.com/fwlink/?LinkId=823950.","typ
    vs2017: eName":"Microsoft.TeamFoundation.Framework.Server.RequestBlockedException, Microsoft.TeamFoundation
    vs2017: .Framework.Server","typeKey":"RequestBlockedException","errorCode":0,"eventId":3000}
    vs2017: At C:\Program Files\WindowsPowerShell\Modules\vagrant-provvin\modules\vs2017.psm1:101 char:17
    vs2017: +                 Invoke-WebRequest -Uri  $uri `
    vs2017: +                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    vs2017:     + CategoryInfo          : InvalidOperation: (System.Net.HttpWebRequest:HttpWebRequest) [Invoke
    vs2017:    -WebRequest], WebException
    vs2017:     + FullyQualifiedErrorId : WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeWe
    vs2017:    bRequestCommand

    vs2017: C:\Users\vagrant\AppData\Local\Temp\enovaMSDN.SonetaPlatformDeveloper.vsix
    vs2017: C:\Users\vagrant\AppData\Local\Temp\MS-vsliveshare.vsls-vs.vsix
    vs2017: C:\Users\vagrant\AppData\Local\Temp\JaredParMSFT.VsVim.vsix
    vs2017: C:\Users\vagrant\AppData\Local\Temp\ZoltanKlinger.RelativeLineNumbers.vsix
    vs2017: C:\Users\vagrant\AppData\Local\Temp\VisualStudioProductTeam.ProductivityPowerPack2017.vsix
    vs2017: C:\Users\vagrant\AppData\Local\Temp\EWoodruff.VisualStudioSpellCheckerVS2017andLater.vsix
    vs2017: C:\Users\vagrant\AppData\Local\Temp\MikeWard-AnnArbor.VSColorOutput.vsix
    vs2017: C:\Users\vagrant\AppData\Local\Temp\MadsKristensen.FileNesting.vsix
    vs2017: C:\Users\vagrant\AppData\Local\Temp\JustinClareburtMSFT.ColorThemesforVisualStudio.vsix
```

> Rate limits breaks the installation... New ideas are needed.
