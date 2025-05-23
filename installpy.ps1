# Define the Python version and installation path
$pythonVersion = "3.9.7"
$installPath = "C:\Python$pythonVersion"

# Download the Python installer
$pythonInstallerUrl = "https://www.python.org/ftp/python/$pythonVersion/python-$pythonVersion-amd64.exe"
$pythonInstallerPath = "$env:TEMP\python-$pythonVersion-amd64.exe"
Invoke-WebRequest -Uri $pythonInstallerUrl -OutFile $pythonInstallerPath

# Install Python
Start-Process -FilePath $pythonInstallerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 TargetDir=$installPath" -Wait

# Verify Python installation
$pythonExe = "$installPath\python.exe"
if (Test-Path $pythonExe) {
    Write-Output "Python $pythonVersion installed successfully."
} else {
    Write-Output "Python installation failed."
    exit 1
}

# Install pip (Python package installer)
$pythonGetPipUrl = "https://bootstrap.pypa.io/get-pip.py"
$pythonGetPipPath = "$env:TEMP\get-pip.py"
Invoke-WebRequest -Uri $pythonGetPipUrl -OutFile $pythonGetPipPath
& $pythonExe $pythonGetPipPath

# Install common packages for system hardening and Windows modules
$packages = @("psutil", "pywin32", "cryptography", "paramiko", "requests")
foreach ($package in $packages) {
    & $pythonExe -m pip install $package
}

Write-Output "Python and required packages installed successfully."
