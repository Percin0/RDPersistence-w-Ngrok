# RDPersistence-w-Ngrok


# Usage
- Choose username and password and the RDP port.
- Set your Ngrok's key
- Run RDPerciRock.bat on victim
- Connect to victim with the username&password created using the Ngrok's url


# Description 
RDPerci is ideal for SOC operators' first analysis. It's a simple script able to enable RDP and add new admin user with the access over it. It's inspired from famous malware that works with RDP. To allow multple RDP sessions it uses termsrv_rdp_patch.ps1 from winposh repository. Lastly, use ngrok to tunnel RDP over internet.

# How it works
RDPerciRock.bat will ask for admin's privileges, when it obtain that it will run. It create new user with a new password (Percin0 and Password123! by default), and try to add to Administrator's group using the default name in different languages. Then enable RDP on the target and change the default port (port 8888 by default). It creates an ACL on WindowsFirewall for RDP connection over the selected port. Lasty download and start ngrok tunnel.

# Disclaimer
Only for analysis do not use without authorization. Only for educational purpose.

# Contact
If you want to help me with any suggestions please contact me to percin0@protonmail.com :)
