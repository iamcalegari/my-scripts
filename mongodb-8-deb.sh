#!/bin/bash

echo "🚀 Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

echo "🚀 Installando o MongoDB 8.0..."
sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list

sudo apt-get update && sudo apt-get install -y mongodb-org

echo "✅ MongoDB 8.0 instalado com sucesso"

echo "🚀 Configurndo replicaset MongoDB..."
touch replicaset.sh

tamborine='"tamborine"'
rs_initiate='"rs.initiate()"'

echo """
#!/bin/bash

sudo systemctl stop mongod.service

sudo cp /etc/mongod.conf /etc/mongod.conf.bkp
sudo sed -i -- 's/#replication:/replication:\n  replSetName: $tamborine/g' /etc/mongod.conf
cat /etc/mongod.conf

sudo systemctl start mongod.service
sleep 1
sudo systemctl status mongod.service &
sleep 2

mongosh --eval=$rs_initiate

""" >> replicaset.sh

chmod +x replicaset.sh
./replicaset.sh
echo "✅ Replicaset configurada com sucesso"
