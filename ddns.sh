#!/usr/bin/env bash

#your domain ID
#domain_id=""
#record to update, must be numeric id (you can find this by inspecting HTML on the dns edit page)
#record_id=""
#your api key
#api_key=""

domain_id=$1
record_id=$2
api_key=$3

### don't change ###
ip=$4
curl --silent -H "Authorization: Bearer $api_key" -H "Content-Type: application/json" \
    -d '{"data": "'"$ip"'"}' \
    -X PUT "https://api.digitalocean.com/v2/domains/$domain_id/records/$record_id" > /dev/null
