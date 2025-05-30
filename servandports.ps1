# Define critical ports and services
$criticalPorts = @(53, 445)  # DNS and SMB ports
$criticalServices = @("DNS", "LanmanServer")  # DNS and SMB services

# Define allowed administrators
$allowedAdmins = @("Administrator", "johncyberstrike", "joecyberstrike", "janecyberstrike", "janicecyberstrike")

# Function to close non-critical ports
function Close-NonCriticalPorts {
    $openPorts = Get-NetTCPConnection -State Listen | Select-Object -ExpandProperty LocalPort
    foreach ($port in $openPorts) {
        if ($port -notin $criticalPorts) {
            Write-Output "Closing port $port"
            Stop-NetTCPConnection -LocalPort $port -Force
        }
    }
}

# Function to stop non-critical services
function Stop-NonCriticalServices {
    $services = Get-Service | Where-Object { $_.Status -eq 'Running' }
    foreach ($service in $services) {
        if ($service.Name -notin $criticalServices) {
            Write-Output "Stopping service $($service.Name)"
            Stop-Service -Name $service.Name -Force
        }
    }
}

# Function to ensure only allowed administrators
function Ensure-AllowedAdmins {
    $adminGroup = [ADSI]"WinNT://./Administrators,group"
    $members = @($adminGroup.psbase.Invoke("Members")) | ForEach-Object { $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) }
    foreach ($member in $members) {
        if ($member -notin $allowedAdmins) {
            Write-Output "Removing $member from Administrators group"
            $adminGroup.Remove("WinNT://./$member")
        }
    }
    foreach ($admin in $allowedAdmins) {
        if ($members -notcontains $admin) {
            Write-Output "Adding $admin to Administrators group"
            $adminGroup.Add("WinNT://./$admin")
        }
    }
}

# Function to ensure only domain users
function Ensure-DomainUsersOnly {
    $localUsers = Get-LocalUser
    foreach ($user in $localUsers) {
        if ($user.Enabled -and $user.Name -notmatch "^(Administrator|Guest|DefaultAccount|WDAGUtilityAccount)$") {
            Write-Output "Disabling local user $($user.Name)"
            Disable-LocalUser -Name $user.Name
        }
    }
}

# Execute functions
Close-NonCriticalPorts
Stop-NonCriticalServices
Ensure-AllowedAdmins
Ensure-DomainUsersOnly

Write-Output "System hardening completed."
