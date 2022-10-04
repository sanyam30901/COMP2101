#!/bin/bash
echo "Report for myvm"
echo ----------------
echo ----------------

echo "Hostname:::$(hostnamectl)"
#showing details about the system information,hostname,operating system, kernel version and machine id.
echo "Ip Address:::$(hostname -I)"
#show the ip address of the machine
echo "Root Filesystem Free Space:::$(df -h /)"
#amount of available disk space in a human friendly number
echo ----------------
echo ----------------

