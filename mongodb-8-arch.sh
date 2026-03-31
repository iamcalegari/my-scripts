#!/bin/bash

# Sai imediatamente se um comando falhar
set -e

# Cores para melhor visualização no terminal (Combina com o estilo do Niri)
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Atualizando o sistema (CachyOS)...${NC}"
sudo pacman -Syu --noconfirm

# Verificar se o yay está instalado
if ! command -v yay &> /dev/null; then
    echo "❌ yay não encontrado. Por favor, instale um AUR helper."
    exit 1
fi

echo -e "${BLUE}🚀 Instalando MongoDB 8.x e Ferramentas...${NC}"
# mongodb-bin para evitar horas de compilação; mongodb-tools-bin para mongodump/restore
yay -S --noconfirm mongodb-bin mongodb-tools-bin

# --- Configuração do ReplicaSet ---

echo -e "${BLUE}🚀 Configurando MongoDB para ReplicaSet...${NC}"

# Parar o serviço para edição segura
sudo systemctl stop mongodb

# Backup da config original
if [ ! -f /etc/mongodb.conf.bkp ]; then
    sudo cp /etc/mongodb.conf /etc/mongodb.conf.bkp
fi

# Ajustando o mongodb.conf
# Removemos qualquer configuração de replication antiga e adicionamos a nova
sudo sed -i '/replication:/d' /etc/mongodb.conf
sudo sed -i '/replSetName:/d' /etc/mongodb.conf

# Adiciona a configuração no final do arquivo de forma limpa
sudo bash -c "cat >> /etc/mongodb.conf" <<EOF
replication:
  replSetName: "tamborine"
EOF

echo -e "${GREEN}✅ Configuração aplicada em /etc/mongodb.conf${NC}"

# Garantir permissões corretas
sudo chown -R mongodb:mongodb /var/lib/mongodb
sudo chown -R mongodb:mongodb /var/log/mongodb
sudo chown mongodb:mongodb /etc/mongodb.conf

# Reiniciar e habilitar
echo -e "${BLUE}🚀 Reiniciando o serviço...${NC}"
sudo systemctl enable --now mongodb

# Esperar o banco subir totalmente antes de rodar o mongosh
echo "⏳ Aguardando o MongoDB iniciar..."
until mongosh --eval "db.adminCommand({ping:1})" &>/dev/null; do
  sleep 2
done

echo -e "${BLUE}🚀 Inicializando ReplicaSet (rs.initiate())...${NC}"
mongosh --eval "rs.initiate()"

echo -e "${GREEN}✨ Tudo pronto! MongoDB 8.x instalado e ReplicaSet 'tamborine' ativo.${NC}"
