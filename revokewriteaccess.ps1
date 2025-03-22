# Define the default users
$defaultUsers = @("Users", "Authenticated Users", "Everyone")

# Function to remove write access for default users
function Remove-WriteAccess {
    param (
        [string]$path
    )

    foreach ($user in $defaultUsers) {
        $acl = Get-Acl -Path $path
        $acl.Access | Where-Object { $_.IdentityReference -eq $user -and $_.FileSystemRights -match "Write" } | ForEach-Object {
            $acl.RemoveAccessRule($_)
        }
        Set-Acl -Path $path -AclObject $acl
    }
}

# Get all directories on the server
$directories = Get-ChildItem -Path "C:\" -Recurse -Directory

# Remove write access for default users from all directories
foreach ($directory in $directories) {
    Write-Output "Removing write access from $($directory.FullName)"
    Remove-WriteAccess -path $directory.FullName
}

Write-Output "Write access removed for default users from all directories."
