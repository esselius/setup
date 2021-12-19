Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -All

& choco install wsl2 --params "/Version:2 /Retry:true" -y

Restart-Computer -Force