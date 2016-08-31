#!/bin/bash

mkdir r_data

# ES - Heap_size:2g
# 跨主機需用 --net=host 放在同一個網段
docker run -d --name es_QQ_master -e ES_HEAP_SIZE=2g -p 9200:9200 -p 9300:9300 jeffsheng/es_labber -Des.node.name="QQ_master" \
  -Des.cluster.name="EyeSocial_cluster for PhoneChiu"
docker run -d --name es_QQ_nodeI  -e ES_HEAP_SIZE=2g --link es_QQ_master:Elas_Mas -p 9201:9200 -p 9301:9300 jeffsheng/es_labber \
  -Des.cluster.name="EyeSocial_cluster for PhoneChiu" -Des.node.name="QQ_node-I" -Des.discovery.zen.ping.unicast.hosts="Elas_Mas"
docker run -d --name es_QQ_nodeII -e ES_HEAP_SIZE=2g --link es_QQ_master:Elas_Mas -p 9202:9200 -p 9302:9300 jeffsheng/es_labber \
  -Des.cluster.name="EyeSocial_cluster for PhoneChiu" -Des.node.name="QQ_node-II" -Des.discovery.zen.ping.unicast.hosts="Elas_Mas"

echo "ES container done."
sleep 2

# Redis
docker run -d --name redis_server -v $PWD/r_data:/data redis redis-server --appendonly yes


echo "Redis container done."
sleep 2
# Web-Server
docker run -d --name webserver --link es_QQ_master:Elas_Mas --link redis_server:R_Server -p 32767:32767 jeffsheng/node_centos_labber

echo "Node.js Webserver done."
echo "Done!!"



# ES 跨主機
docker run -d --name es_QQ_master -e ES_HEAP_SIZE=2g --net=host -p 9200:9200 -p 9300:9300 jeffsheng/es_labber -Des.node.name="QQ_master" \
  -Des.cluster.name="EyeSocial_cluster for AirforceI"
docker run -d --name es_QQ_nodeI  -e ES_HEAP_SIZE=2g --net=host -p 9200:9200 -p 9300:9300 jeffsheng/es_labber \
  -Des.cluster.name="EyeSocial_cluster for AirforceI" -Des.node.name="QQ_node-I" -Des.discovery.zen.ping.unicast.hosts="master_ip"
docker run -d --name es_QQ_nodeII -e ES_HEAP_SIZE=2g  -p 9200:9200 -p 9300:9300 jeffsheng/es_labber \
  -Des.cluster.name="EyeSocial_cluster for AirforceI" -Des.node.name="QQ_node-II" -Des.discovery.zen.ping.unicast.hosts="master_ip"

