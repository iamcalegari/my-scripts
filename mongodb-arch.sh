#!/bin/bash

echo "🚀 Atualizando o sistema..."
sudo pacman -Syu

echo "🚀 Installando o MongoDB 6.0..."
yay -S mongodb-bin 
echo "✅ MongoDB 6.0 instalado com sucesso"

echo "🚀 Configurndo replicaset MongoDB..."
touch replicaset.sh

tamborine='"tamborine"'
rs_initiate='"rs.initiate()"'

echo """
#!/bin/bash

sudo systemctl stop mongodb.service

sudo cp /etc/mongodb.conf /etc/mongodb.conf.bkp
sudo sed -i -- 's/#replication:/replication:\n  replSetName: $tamborine/g' /etc/mongodb.conf
cat /etc/mongodb.conf

sudo systemctl start mongodb.service
sleep 1
sudo systemctl status mongodb.service &
sleep 2
mongosh --eval=$rs_initiate

""" >> replicaset.sh

chmod +x replicaset.sh
./replicaset.sh
echo "✅ Replicaset configurada com sucesso"
