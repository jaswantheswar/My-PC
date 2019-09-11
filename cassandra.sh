#!/bin/bash

# followed below url to install cassandra 

# url : https://linuxize.com/post/how-to-install-apache-cassandra-on-ubuntu-18-04/

# need a user with sudo privleges

sudo apt update
sudo apt install openjdk-8-jdk -y
java -version
sudo apt install apt-transport-https -y
wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
sudo sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 311x main" > /etc/apt/sources.list.d/cassandra.list'
sudo apt update
sudo apt install cassandra -y
nodetool status

# Create a super user and then change the password of cassandra user

sudo sed -i 's/authenticator: AllowAllAuthenticator/authenticator: org.apache.cassandra.auth.PasswordAuthenticator/g' /etc/cassandra/cassandra.yaml

sudo sed -i 's/authorizer: AllowAllAuthorizer/authorizer: org.apache.cassandra.auth.CassandraAuthorizer/g' /etc/cassandra/cassandra.yaml

sudo systemctl restart cassandra
wait
sleep 30

#creating user pradeep

cqlsh -u cassandra -p cassandra<<EOF
CREATE ROLE pradeep WITH PASSWORD = 'pradeep123' AND SUPERUSER = true AND LOGIN = true;
EOF

#update password of cassandra user

cqlsh -u pradeep -p pradeep123<<EOF
ALTER ROLE cassandra WITH SUPERUSER = true AND LOGIN = true AND password='pradeep';
EOF

sudo systemctl restart cassandra



# if want to change cluster name, follow below commented commands

# cqlsh
# UPDATE system.local SET cluster_name = 'Linuxize Cluster' WHERE KEY = 'local';
# sed -i 's/cluster_name = 'Linuxize Cluster'/cluster_name = '<Name> Cluster'/g' /etc/cassandra/cassandra.yaml
# nodetool flush system
# sudo systemctl restart cassandra
