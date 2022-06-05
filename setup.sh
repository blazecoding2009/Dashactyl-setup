#!/bin/bash
cat <<EOF
  ____            _                _         _         _ 
 |  _ \  __ _ ___| |__   __ _  ___| |_ _   _| | __   _/ |
 | | | |/ _  / __|  _ \ / _  |/ __| __| | | | | \ \ / / |
 | |_| | (_| \__ \ | | | (_| | (__| |_| |_| | |  \ V /| |
 |____/ \__,_|___/_| |_|\__,_|\___|\__|\__, |_|   \_/ |_|
                                       |___/             
                      Setup Client


EOF

if (( EUID != 0 )); then
      echo "This script must be executed with root privileges (sudo)."   
      exit 1
fi

cat <<EOF
Welcome to the setup client of Dashactyl!
If you already have Dashactyl setup, there's no need to run this!
The setup client is starting now...
EOF

read -p "Let's start with the basics, What port would you like to run Dashactyl? (Do not use port 80 and 443)" port
read -p "Enter the secret cookie password: " cookiepassword

#Random cookie passwd generator if blank needed.

sed -n 's/4440/$port/1' settings.yml
sed -n 's/Enter your session password here./$cookiepassword/1' settings.yml

read -p "Enter the url where Dashactyl will be running at (Don't enter https:// or http://) " url
read -p "Is it secure? (Means HTTPS:// or not. Reply with y/n)" secure
read -p "Enter the Discord OAuth Client ID: " clientid
read -p "Enter the Discord OAuth Client Secret: " clientsecret
read -p "Enter the Discord Bot Token: " token
read -p "Enter the Discord Server ID: " guildid
read -p "Enter the Discord Registered Role ID: " roleid

if [[ secure == "y" ]]; then
      secure = "https://"
      fullurl = secure + url
elif [[secure == "n"]]; then
      secure = "http://"
      fullurl = secure + url
fi

sed -n 's/http://localhost:8000/$fullurl/1' settings.yml
sed -n 's/localhost:4440/$url/1' settings.yml


read -p "Enter the panel url include http:// or https://): " panelurl
read -p "Enter the admin API key of panel: " panelapi

sed -n 's/Enter your Pterodactyl Panel domain here./$panelurl/1' settings.yml
sed -n 's/Enter your Pterodactyl Panel application API key here./$panelapi/1' settings.yml

read -p "Do you want to setup an audit log webhook? (y/n)" webhook_prompt
if [[ webhook_prompt == "y"]]; then
      read -p "What's the webhook URL?" webhook_url
      sed -n 's/false # enable or disable the Audit Logs/true # enable or disable the Audit Logs/1' settings.yml
      sed -n 's/Enter your webhook URL/$webhook_url/1' settings.yml
fi

echo "Let's setup the shop now"
read -p "Enter the Location Id of Server Creation: " locationid
read -p "Enter the Location Name, this will be displayed on the dashboard: " locationname
read -p "Enter The CPU Price for Shop Per 100%: " cpuprice
read -p "Enter The Ram Price for Shop Per 100MB: " ramprice
read -p "Enter The DISK Price for Shop Per 100MB: " diskprice
read -p "Enter The Server Slot Price for Shop Per 1 Slot: " slotprice
