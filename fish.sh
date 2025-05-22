#! /bin/bash

PACKAGES='fish wget git curl'

echo "🚀 Atualizando o sistema e instalando o fish e os pacotes necessários..."
if [ -x "$(command -v apt-get)" ]; then sudo apt update && sudo apt upgrade && sudo apt-get install $PACKAGES
elif [ -x "$(command -v dnf)" ];     then sudo dnf upgrade --refresh && sudo dnf install $PACKAGES
elif [ -x "$(command -v zypper)" ];  then sudo zypper up && sudo zypper in $PACKAGES
elif [ -x "$(command -v pacman)" ];  then sudo pacman -Syu && sudo pacman -Syu $PACKAGES
fi

FONTS_PATH="$HOME/.local/share/fonts/"

echo "🚀 Instalando fontes... [FiraCode Nerd Font]"

mkdir -p $FONTS_PATH

get_latest_release() {
 git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' $1 \
 | tail --lines=1 \
 | cut --delimiter='/' --fields=3 
}

FIRA_CODE_LAST_RELEASE=$(get_latest_release https://github.com/ryanoasis/nerd-fonts.git)

wget -c -O $FONTS_PATH/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/$FIRA_CODE_LAST_RELEASE/FiraCode.zip

sleep 5

unzip -q $FONTS_PATH/FiraCode.zip -d $FONTS_PATH/ && rm $FONTS_PATH/FiraCode.zip

NVM_LAST_RELEASE=$(get_latest_release https://github.com/nvm-sh/nvm.git)

echo "✨ Estilizando o seu fish-shell..."
curl -sS https://starship.rs/install.sh | sh
echo "starship init fish | source" >> ~/.config/fish/config.fish

echo "🚀 Instalando o NPM para o Fish..."
fish 
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish 
omf install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_LAST_RELEASE/install.sh | bash 
nvm list-remote
nvm install 18


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

echo "Vamos alterar o Shell padrao do terminal para o fish-shell"
chsh -s /usr/bin/fish

echo "🔄 Reinicie o terminal para ver as modificações"
