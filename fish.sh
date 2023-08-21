#! /bin/bash

PACKAGES='fish wget'

echo "🚀 Atualizando o sistema e instalando o fish e os pacotes necessários..."
if [ -x "$(command -v apt-get)" ]; then sudo apt update && sudo apt upgrade && sudo apt-get install $PACKAGES
elif [ -x "$(command -v dnf)" ];     then sudo dnf upgrade --refresh && sudo dnf install $PACKAGES
elif [ -x "$(command -v zypper)" ];  then sudo zypper up && sudo zypper in $PACKAGES
elif [ -x "$(command -v pacman)" ];  then sudo pacman -Syu && sudo pacman -Syu $PACKAGES
fi

FONTS_PATH="$HOME/.local/share/fonts"

echo "🚀 Instalando fontes... [FiraCode Nerd Font]"
mkdir $FONTS_PATH

wget -c -O $FONTS_PATH/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/FiraCode.zip

sleep 5

unzip -q $FONTS_PATHs/FiraCode.zip -d $FONTS_PATH/ && rm $FONTS_PATH/FiraCode.zip

echo "✨ Estilizando o seu fish-shell..."
curl -sS https://starship.rs/install.sh | sh
echo "starship init fish | source" >> ~/.config/fish/config.fish

echo "🚀 Instalando o NPM para o Fish..."
fish &
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
nvm list-remote
nvm install 16.17.1


echo "🐟 O melhor Shell foi instalado com sucesso!"
echo """
Altere o Shell utilizado no seu terminal.
Caso seja o terminal padrao do gnome va em:

1. Preferences > Clique para editar um perfil > Aba Command 
2. Marque a caixinha:
☑ Run a custom command instead of the default shell
3. Na caixa de texto digite:
fish
4. Altere a fonte utilizada no terminal para a Fira Code Nerd Fonts Regular

Pronto!
"""
echo "🔄 Reinicie o terminal para ver as modificações"
