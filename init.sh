#!/bin/bash

echo "********************************************"
echo "*          TUHA-V2 INITAL ENV START        *"
echo "*REQ INSTALL                               *"
echo "* 1. GIT                                   *"
echo "* 2. COMPOSER                              *"
echo "* 3. CONFIG GIT SSH KEY                    *"
echo "********************************************"
read -p "Y to start, N to cancel:" choice
if [ "$choice" != "Y" ]; then
    echo "Canceling ..."
    sleep 3
    exit 2;
fi

#source start
if [ -d "$PWD/applications/account-ui" ]; then
    read -p "Folder source exist. Delete it ? Y/C :" choice
    if [ "$choice" != "Y" ]; then
        echo "Canceling ..."
        sleep 3
        exit 2;
    fi
    rm -rf ./applications/account-ui
fi
git clone git@gitlab.com:paldeveloper/tuhav2-acount-ui.git ./applications/account-ui
cd ./applications/account-ui 
composer update 
cd ../..gi

if [ -d "$PWD/applications/account-api" ]; then
    read -p "Folder source exist. Delete it ? Y/C :" choice
    if [ "$choice" != "Y" ]; then
        echo "Canceling ..."
        sleep 3
        exit 2;
    fi
    rm -rf ./applications/account-ui
fi
git clone git@gitlab.com:paldeveloper/tuhav2-account-api.git ./applications/account-api
cd ./applications/account-api
composer update 
cd ../..

#start docker
docker compose up -d

#start register api
curl --location --request POST '127.0.0.1:8001/services' \
--header 'Content-Type: application/json' \
--data-raw '{
    "id" : "9748f662-7711-4a90-8186-dc02f10eb0f5",
    "name" : "pal_account_services",
    "protocol" : "http",
    "host" : "account-api",
    "port" : 80
}'

curl --location --request POST '127.0.0.1:8001/routes' \
--header 'Content-Type: application/json' \
--data-raw '{
    "id": "d35165e2-d03e-461a-bdeb-dad0a112abfe",
    "created_at": 1422386534,
    "updated_at": 1422386534,
    "name": "account-route",
    "protocols": ["http"],
    "paths": ["/account/v1"],
    "https_redirect_status_code": 426,
    "regex_priority": 0,
    "strip_path": true,
    "path_handling": "v0",
    "preserve_host": false,
    "request_buffering": true,
    "response_buffering": true,
    "tags": ["user-level", "low-priority"],
    "service": {"id":"9748f662-7711-4a90-8186-dc02f10eb0f5"}
}'

#stop docker
docker compose down

sleep 10

