#!/bin/bash

#IP HOST
ip_host="192.168.1"

common_ports=(
    20    # FTP Data
    21    # FTP Control
    22    # SSH
    23    # Telnet
    25    # SMTP
    53    # DNS
    67    # DHCP Server
    68    # DHCP Client
    69    # TFTP
    80    # HTTP
    110   # POP3
    111   # RPCBind / SunRPC
    123   # NTP
    135   # Microsoft RPC
    137   # NetBIOS Name
    138   # NetBIOS Datagram
    139   # NetBIOS Session
    143   # IMAP
    161   # SNMP
    162   # SNMP Trap
    389   # LDAP
    443   # HTTPS
    445   # Microsoft-DS (SMB)
    465   # SMTPS
    500   # IKE (IPSec)
    514   # Syslog
    587   # SMTP Submission
    636   # LDAPS
    873   # rsync
    993   # IMAPS
    995   # POP3S
    1080  # SOCKS Proxy
    1433  # MS SQL Server
    1521  # Oracle
    1723  # PPTP VPN
    1883  # MQTT
    2049  # NFS
    2082  # cPanel
    2083  # cPanel SSL
    2086  # WHM
    2087  # WHM SSL
    3306  # MySQL
    3389  # RDP
    4444  # Metasploit / Pentesting
    5000  # UPnP / Flask apps
    5432  # PostgreSQL
    5900  # VNC
    5984  # CouchDB
    6379  # Redis
    6667  # IRC
    8000  # HTTP Alternate
    8008  # HTTP Alternate
    8080  # HTTP Proxy / Alternate
    8443  # HTTPS Alternate
    8888  # Alternate Web Services
    9000  # SonarQube / dev tools
    9090  # Web admin interfaces
    9200  # Elasticsearch
    10000 # Webmin
)

#Ctrl+C
function ctrl_c() {
    echo -e "\n\nSaliendo del programa"
    tput cnorm
    exit 1
}
trap ctrl_c SIGINT

tput civis
#Escanea en paralelo todos los hosts de una subred /24 mediante pings rápidos y muestra cuáles responden.

echo -e "\n------------------VALIDANDO HOSTS ACTIVOS EN LA RED ------------------------------\n"
for i in $(seq 1 254); do
    timeout 1 bash -c "ping -c 1 $ip_host.$i" &>/dev/null && echo "[+] Host 192.168.1.$i - ACTIVE" &
done

#Prueba en paralelo una lista de puertos comunes en todos los hosts de una subred /24 y muestra cuáles están abiertos.
echo -e "\n------------------VALIDANDO PUERTOS COMUNES EN HOSTS DESCUBIERTOS EN LA RED------------------------------\n"
for i in $(seq 1 254); do
    for port in "${common_ports[@]}"; do
        timeout 1 bash -c "echo '' > /dev/tcp/$ip_host.$i/$port" 2>/dev/null && echo "[+] Host 192.168.1.$i - PORT ($port) (OPEN)" &
    done
done
tput cnorm

wait
