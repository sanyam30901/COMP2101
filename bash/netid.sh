#!/bin/bash

echo "SANYAM -- BASH CHALLENGE LAB 4"

givenInterfaceCMDLINE=""
while [ $# -gt 0 ]; do
    case "$1" in
    -v)
        verbose="yes"
        ;;
    *)
        if [ "$givenInterfaceCMDLINE" == "" ]; then
            givenInterfaceCMDLINE="$1"
        fi
        ;;
    esac
    shift
done 

#####
# Once per host report
#####

[ "$verbose" = "yes" ] && echo "Gathering host information"
my_hostname="$(hostname) / $(hostname -I)"
[ "$verbose" = "yes" ] && echo "Identifying default route"
default_router_address=$(ip r s default | awk '{print $3}')
default_router_name=$(getent hosts $default_router_address | awk '{print $2}')
[ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname"
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_address | awk '{print $2}')
cat <<EOF

System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name

EOF

#####
# End of Once per host report
#####

#####
# Per-interface report
#####

if [ "$givenInterfaceCMDLINE" != "" ]; then
    interface=$givenInterfaceCMDLINE
    [ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interface"
    [ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"
    ipv4_address=$(ip a s $interface | awk -F '[/ ]+' '/inet /{print $3}')
    ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')
    [ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
    network_address=$(ip route list dev $interface scope link | cut -d ' ' -f 1)
    network_number=$(cut -d / -f 1 <<<"$network_address")
    network_name=$(getent networks $network_number | awk '{print $1}')

cat <<EOF

Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF

fi

#####
# End of per-interface report
#####

for interface in $(ifconfig | grep -o -w '^[^ ][^ ]*:' | tr -d :); do
    [ $interface = "lo" ] && continue
    [ "$verbose" = "yes" ] && echo "Reporting on interface(s): $interface"
    [ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"
    ipv4_address=$(ip a s $interface | awk -F '[/ ]+' '/inet /{print $3}')
    ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')
    [ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
    network_address=$(ip route list dev $interface scope link | cut -d ' ' -f 1)
    network_number=$(cut -d / -f 1 <<<"$network_address")
    network_name=$(getent networks $network_number | awk '{print $1}')

cat <<EOF

Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF

done
