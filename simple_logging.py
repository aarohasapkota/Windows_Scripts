import time
import psutil
import win32evtlog
import win32serviceutil
import socket
from termcolor import colored

def log_event(message, category):
    print(colored(f"{category}:", 'blue'))
    print(message)

def get_user_login_events():
    # Placeholder for user login events
    return ["User login detected"]

def get_new_services_started():
    services = []
    for service in psutil.win_service_iter():
        if service.status() == 'running':
            services.append(service.name())
    return services

def get_services_terminated():
    services = []
    for service in psutil.win_service_iter():
        if service.status() == 'stopped':
            services.append(service.name())
    return services

def get_failed_logon_events():
    # Placeholder for failed logon events
    return ["Failed logon detected"]

def get_new_ports_opened():
    ports = []
    for conn in psutil.net_connections(kind='inet'):
        if conn.status == 'LISTEN':
            ports.append(conn.laddr.port)
    return ports

def get_ports_closed():
    ports = []
    for conn in psutil.net_connections(kind='inet'):
        if conn.status == 'CLOSE_WAIT':
            ports.append(conn.laddr.port)
    return ports

def get_remote_shell_opened():
    shells = []
    for proc in psutil.process_iter(['pid', 'name']):
        if proc.info['name'] in ['cmd.exe', 'powershell.exe']:
            shells.append(proc.info['name'])
    return shells

def main():
    while True:
        log_event(get_user_login_events(), "User Login Events")
        log_event(get_new_services_started(), "New Services Started")
        log_event(get_services_terminated(), "Services Termination")
        log_event(get_failed_logon_events(), "Failed Logon")
        log_event(get_new_ports_opened(), "New Ports Opened")
        log_event(get_ports_closed(), "Ports Closed")
        log_event(get_remote_shell_opened(), "Remote Shell Opened")
        
        time.sleep(300)  # Wait for 5 minutes

if __name__ == "__main__":
    main()