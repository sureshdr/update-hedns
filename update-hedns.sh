#!/bin/bash

# Script to update Hurricane Electric DNS Service
# for updated version of the script, go to http://github.com/sureshdr/update-hedns

domain=<your dynamic domain hostname>
password=<generate a password from the HE DNS interface>

# Get the external IP address
IP=`curl -sS https://wtfismyip.com/text`

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGFILE="$DIR/ip-update.log"
IPFILE="$DIR/current.ip"

if ! valid_ip $IP; then
    echo "[$(date)] Invalid IP address: $IP" >> "$LOGFILE"
    exit 1
fi

# Check if the IP has changed
if [ ! -f "$IPFILE" ]
    then
    touch "$IPFILE"
fi

if grep -Fxq "$IP" "$IPFILE"; then
    # code if found
    echo "[$(date)] IP is still $IP. Exiting" >> "$LOGFILE"
    exit 0
else
    echo "[$(date)] IP has changed to $IP" >> "$LOGFILE"
	
	curl -4 https://$domain:$password@dyn.dns.he.net/nic/update?hostname=$domain
	echo "$IP" > "$IPFILE"
fi