#!/bin/sh

set -e

CONFFILE=/etc/privoxy/config
PIDFILE=/var/run/privoxy.pid

DROUTE=$(ip route | grep default | awk '{print $3}')
HOMENET=192.168.0.0/16
HOMENET2=10.0.0.0/8
HOMENET3=172.16.0.0/12
ip route add $HOMENET3 via $DROUTE
ip route add $HOMENET2 via $DROUTE
ip route add $HOMENET via $DROUTE
iptables -I OUTPUT -d $HOMENET -j ACCEPT
iptables -A OUTPUT -d $HOMENET2 -j ACCEPT
iptables -A OUTPUT -d $HOMENET3 -j ACCEPT

oldip=$(curl -s ifconfig.me)

echo "Generating wireguard configuration for..."
echo $EMAIL
echo $COUNTRY
echo $DEVICE
SESSIONID=x

FILE=/etc/wireguard/sessid.txt
if test -f "$FILE"; then
    SESSIONID=`cat $FILE`
fi

python3 /usr/local/bin/fetchwg.py $EMAIL $PASSWORD $COUNTRY $DEVICE $SESSIONID

sleep 1

sed -i 's/DNS.*/DNS = 1.1.1.1,1.0.0.1/' /etc/wireguard/*.conf
ifname=$(basename $(ls -1 /etc/wireguard/*.conf | head -1) .conf)

echo "wg-quick up {$ifname}"
wg-quick up /etc/wireguard/$ifname.conf

if [ ! -f "${CONFFILE}" ]; then
	echo "Privoxy configuration file ${CONFFILE} not found!"
	exit 1
fi

echo "Regular IP: ${oldip}"

echo "Starting Privoxy..."
sleep 3 && newip=$(curl -s ifconfig.me) && echo "Wireguard IP: ${newip}" &
/usr/sbin/privoxy --no-daemon --pidfile "${PIDFILE}" "${CONFFILE}"