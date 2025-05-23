# Define the registry paths for Office applications
$officePaths = @(
    "HKCU:\Software\Policies\Microsoft\Office\16.0\Word\Security\Trusted Locations",
    "HKCU:\Software\Policies\Microsoft\Office\16.0\Excel\Security\Trusted Locations",
    "HKCU:\Software\Policies\Microsoft\Office\16.0\PowerPoint\Security\Trusted Locations"
)

# Function to disable macros
function Disable-Macros {
    param (
        [string]$path
    )

    # Set the registry key to disable macros
    Set-ItemProperty -Path $path -Name "VBAWarnings" -Value 4
}

# Disable macros for each Office application
foreach ($path in $officePaths) {
    Write-Output "Disabling macros for $path"
    Disable-Macros -path $path
}

Write-Output "Macros disabled for Microsoft Office files transmitted by email."
