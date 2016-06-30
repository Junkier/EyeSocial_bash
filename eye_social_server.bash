#!/bin/bash

mkdir r_data

# ES
docker run -d --name es_QQ_master -p 9200:9200 -p 9300:9300 jeffsheng/es_labber -Des.node.name="QQ_master"

echo "ES container done."
sleep 2

# Redis
docker run -d --name redis_server -v $PWD/r_data:/data redis redis-server --appendonly yes

echo "Redis container done."
sleep 2
# Web-Server
docker run -d --name webserver --link es_QQ_master:Elas_Mas --link redis_server:R_Server -p 32767:32767 jeffsheng/node_labber

echo "Node.js Webserver done."
echo "Done!!"
