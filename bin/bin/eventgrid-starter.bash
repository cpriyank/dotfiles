#!/usr/bin/env bash
# sitename=ninethirtyeightwebviewer
# topicname=jobcrawlerrebuildtopic
topicname=ninethirtyeighttopic
# resourceGroup=rg-190725102511
resourceGroup=ninethirtyeightgroup
# endpoint=https://$sitename.azurewebsites.net/api/updates

# az eventgrid event-subscription create \
#   -g $resourceGroup \
#   --topic-name $topicname \
#   --name demoViewerSub \
#   --endpoint $endpoint
endpoint=$(az eventgrid topic show --name $topicname -g $resourceGroup --query "endpoint" --output tsv)
echo "$endpoint"
key=$(az eventgrid topic key list --name $topicname -g $resourceGroup --query "key1" --output tsv)

event='[ {"id": "734852347809234432", "eventType": "CrawlerMasterRebuildEvent", "subject": "RebuildAssetIndex", "eventTime": "'$(date +%Y-%m-%dT%H:%M:%S%z)'", "data":{ "make": "Ducati", "model": "Monster"},"dataVersion": "1.0"} ]'

curl -X POST -H "aeg-sas-key: $key" -d "$event" "$endpoint"
