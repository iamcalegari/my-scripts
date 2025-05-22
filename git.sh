#! /bin/bash

echo "🚀 Vamos configurar o seu git, chave ssh e mais..."

PACKAGES='git'

echo "🚀 Atualizando o sistema e instalando o fish e os pacotes necessários..."
if [ -x "$(command -v apt-get)" ]; then sudo apt update && sudo apt upgrade && sudo apt-get install $PACKAGES
elif [ -x "$(command -v dnf)" ];     then sudo dnf upgrade --refresh && sudo dnf install $PACKAGES
elif [ -x "$(command -v zypper)" ];  then sudo zypper up && sudo zypper in $PACKAGES
elif [ -x "$(command -v pacman)" ];  then sudo pacman -Syu && sudo pacman -Syu $PACKAGES
fi

touch ~/.npmrc
echo "@tamborineapps:registry=https://npm.pkg.github.com/" >> ~/.npmrc

read -p 'Username do github: ' uservar
read -p 'Email do github: ' mailvar

git config --global user.name $uservar
git config --global user.email $mailvar
git config --global --add --bool push.autoSetupRemote true

ssh-keygen -t ed25519 -C $mailvar
eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519
echo " ⬇ Copie a chave ssh abaixo e cole no github ⬇"
cat ~/.ssh/id_ed25519.pub
echo "Link para criacao da chave ssh no github: https://github.com/settings/ssh/new"
