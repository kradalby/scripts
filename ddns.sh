#!/bin/bash

#your domain ID
domain_id="fap.no"
#record to update, must be numeric id (you can find this by inspecting HTML on the dns edit page)
record_id="3521543"
#your api key
api_key="6fe23b7ae111a962f16f37a3c023ef8434074ff228a6b08fbdc1d952f8884e86"

domain_id=$1
record_id=$2
api_key=$3

### don't change ###
ip="$(curl --silent http://canihazip.com/s)"
curl --silent -H "Authorization: Bearer $api_key" -H "Content-Type: application/json" \
    -d '{"data": "'"$ip"'"}' \
    -X PUT "https://api.digitalocean.com/v2/domains/$domain_id/records/$record_id"
