#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/alexxa/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m" 
COLOR1="$(cat /etc/alexxa/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/alexxa/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"  
WH='\033[1;37m'                  
###########- END COLOR CODE -##########

BURIQ () {
    curl -sS https://raw.githubusercontent.com/DryanZ/permission/aio/access > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/DryanZ/permission/aio/access | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/DryanZ/permission/aio/access | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
red='\e[1;31m'
green='\e[1;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ -f /home/needupdate ]; then
red "Your script need to update first !"
exit 0
elif [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
red "Permission Denied!"
exit 0
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}               ${WH}• SERVER STATUS •               ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
systemctl daemon-reload
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}Starting ...                        $COLOR1 ${NC}"
sleep 1
systemctl restart ssh
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}Restarting SSH Services             $COLOR1 ${NC}"
sleep 1
systemctl restart squid
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}Restarting Squid Services           $COLOR1 ${NC}"
sleep 1
systemctl restart openvpn
systemctl restart --now openvpn-server@server-tcp-1194
systemctl restart --now openvpn-server@server-udp-2200
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}Restarting OpenVPN Services         $COLOR1 ${NC}"
sleep 1
systemctl restart nginx
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}Restarting Nginx Services           $COLOR1 ${NC}"
sleep 1
systemctl restart dropbear
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}Restarting Dropbear Services        $COLOR1 ${NC}"
sleep 1
systemctl restart ws-dropbear
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}Restarting Ws-Dropbear Services     $COLOR1 ${NC}"
sleep 1
systemctl restart ws-stunnel
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}Restarting Ws-Stunnel Services      $COLOR1 ${NC}"
sleep 1
systemctl restart stunnel4
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}Restarting Stunnel4 Services        $COLOR1 ${NC}"
sleep 1
systemctl restart xray
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}Restarting Xray Services            $COLOR1 ${NC}"
sleep 1
systemctl restart cron
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}Restarting Cron Services            $COLOR1 ${NC}"
echo -e " $COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}] ${COLOR1}• ${WH}All Services Restates Successfully  $COLOR1 ${NC}"
sleep 1
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}" 
echo -e "$COLOR1┌────────────────────── ${WH}BY${NC} ${COLOR1}───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}                ${WH}• 𝔻ℝ𝕐𝔸ℕℤ 𝕊ℂℝ𝕀ℙ𝕋 •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
esac