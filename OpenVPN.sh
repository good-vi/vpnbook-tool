#!/bin/bash
passfile="./LogPass.conf"

curpass=dd4e58m

echo vpnbook > $passfile
echo -n $curpass >> $passfile

region=`zenity --list --column='Выберите тип региона': euro1 euro2 de4 us1 us2 ca`
connection_type=`zenity --list --column='Выберите тип соединения:' tcp443 udp25000 tcp80 udp53`

xterm -e sudo openvpn --script-security 2 --config "./$region/vpnbook-$region-$connection_type.ovpn" --auth-user-pass "$passfile"