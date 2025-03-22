These Scripts will work on Windows Server
Run the Python Installation File First



    # Import the Update module
    Import-Module PSWindowsUpdate

    # Check for available updates
    Get-WindowsUpdate

    # Install available updates
    Install-WindowsUpdate -AcceptAll -AutoReboot
