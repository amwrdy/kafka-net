echo updating Repo...
echo Y | sudo apt update && echo Y | sudo apt install openjdk-11-jdk openjdk-11-jre
echo downloading confluent...
wget https://packages.confluent.io/archive/6.0/confluent-community-6.0.1.tar.gz
tar -xzf confluent-community-6.0.1.tar.gz
wget http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz 
mkdir confluenthub && mv confluent-hub-client-latest.tar.gz confluenthub/
cd confluenthub/
tar -xzf confluent-hub-client-latest.tar.gz
cd ..
echo 'export PATH=$PATH:~/confluent-6.0.1/bin' >> ~/.profile
echo 'export PATH=$PATH:~/confluenthub/bin' >> ~/.profile
source ~/.profile

#zookeeper and kafka
echo Starting Zookeeper and Kafka...
echo "~/confluent-6.0.1/bin/zookeeper-server-start ~/confluent-6.0.1/etc/kafka/zookeeper.properties 2>&1 &" > 1.startZookeeper.sh
echo "~/confluent-6.0.1/bin/kafka-server-start ~/confluent-6.0.1/etc/kafka/server.properties  2>&1 &" > 2.startKafka.sh

echo done setup and config

#generate Startup script
echo "kafka-topics --create --topic csv --zookeeper localhost:2181 --partitions 1 --replication-factor 1" \
"cd ~/confluent-6.0.1/" \
"echo y| confluent-hub install jcustenborder/kafka-connect-spooldir:latest"\
"connect-distributed ./etc/kafka/connect-distributed.properties" >> 3.final.sh
chmod +x *.sh