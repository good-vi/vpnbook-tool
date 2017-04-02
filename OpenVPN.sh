#!/bin/bash
passfile="./LogPass.conf"

newpass=`wget http://www.vpnbook.com/freevpn -O - | grep -m 1 Password | tr -s "<>" "\n" | sed '5!d'`
curpass=`sed '2!d' $passfile`

# check HTML parsing
if [[ -z "$newpass" ]]; then
  zenity --warning --text "Не могу взять пароль. \n Сходите в ручную: http://www.vpnbook.com/freevpn"
  exit
fi

# test if pass has changed
if [[ "$curpass" != "$newpass" ]]; then
  zenity --question --text "Пароль изменен на: \"$newpass\" \n Обновить?"
  if [ $? -eq 0 ]; then # update password file
    echo vpnbook > $passfile
    echo -n $newpass >> $passfile
  fi
fi

region=`zenity --list --column='Выберите тип региона': euro1 euro2`
connection_type=`zenity --list --column='Выберите тип соединения:' tcp443 udp25000 tcp80 udp53`

echo "$connection_type"
echo "$region"

xterm -e sudo openvpn --script-security 2 --config "./$region/vpnbook-$region-$connection_type.ovpn" --auth-user-pass "$passfile"