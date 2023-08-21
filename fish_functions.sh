#! /bin/bash
clear 

FISH_FUNCTION_PATH="$HOME/.config/fish/functions"

HELP_MENU="""
[a/alias] ........................... Como criar um novo alias
[e/env] ......................... Como setar novas variáveis ambientes persistentes
[f/fn] .......................... Como criar uma nova function
[t/tfn] ......................... Como criar um alias para rodar teste de um arquivo de testes apenas

[s/sair] ........................... Sair
"""

HELP_FN="""
💡 Sempre que quiser criar uma nova function basta seguir o template:
> function <fn-1>
    command [args] [options] ...
  end

💬 Function para entrar no repositório 'main':
> function tm
    cd $MAIN_PATH
  end

💬 Function para alterar a mensagem ao iniciar um novo terminal (essa é uma função built-in do fish, porém pode ser editada):
> function fish_greeting
    echo 'keep calm and drink coffe ☕️'
  end

💬 Lembre-se de salvar essa function para estar disponivel para as outras sessions do terminal:
> funcsave <fn-1> <fn-2> ... <fn-x>

💬 Salvar a function 'tm' que criamos:
> funcsave tm fish_greeting

🚀 Uso:
-> Entra no repositório e abre o vs-code nele
keep calm and drink coffe ☕️

> tm
> code .
"""

HELP_A="""
💡 Para criar aliases: 
> set -s <alias>=<'command --options'>

💬 Alias para git checkout, por exemplo:
> set -s co='git checkout'

🚀 Uso:
-> Cria e faz checkout para a branch 'nova/branch'
> co -b nova/branch

-> Checkout para a branch 'develop'
> co nova/branch
"""

HELP_ENV="""
💡 Para criar variáveis ambiente persistentes:
> set -xU VARIAVEL valor

💬 Exportar NODE_ENV=test, por exemplo:
> set -xU NODE_ENV test

💬 Agora não precisa de rodar os comandos passando a variável ambiente 'NODE_ENV=test'.
"""

HELP_TFN="""
💡 Para criar aliases para rodar o teste de um arquivo apenas para outros pacotes:
> function <nome-do-alias>
      npx lerna run test:file --scope @tamborineapps/<pacote> --skip-nx-cache -- $MAIN_PATH/<libs-ou-applications>/<pacote>/test/$argv
  end

💬 Criar um alias para teste de um arquivo para o pacote banking-accounting:
> function tba
      npx lerna run test:file --scope @tamborineapps/banking-accounting --skip-nx-cache -- $MAIN_PATH/applications/banking-accounting/test/$argv
  end
> funcsave tba

🚀 Uso:
> tba services/classificar-atrasos.test.js
"""

HELP_END="""
💡 Sempre que precisar relembrar algum comando desse help basta rodar o esse script com o argumento 'h' ou 'help'
> ./fish_functions.sh h
ou
> ./fish_functions.sh help


☮️ Bom trabalho ☮️
Equipe Tamborine.
"""

show_menu()
{
      SHOW_MENU=true
      while SHOW_MENU=true
      do
            echo "---------------------------------------------- [Help] ----------------------------------------------"
            echo "${HELP_MENU}"
            read -p "R: " option
            option=${option:-s}
            clear
            case $option in
                  a) echo "${HELP_A}" ;;
                  alias) echo "${HELP_A}" ;;
                  e) echo "${HELP_ENV}" ;;
                  env) echo "${HELP_ENV}" ;;
                  f) echo "${HELP_FN}" ;;
                  fn) echo "${HELP_FN}" ;;
                  s) break ;;
                  sair) break ;;
                  t) echo "${HELP_TFN}" ;;
                  tnf) echo "${HELP_TFN}" ;;
                  *) 
                        SHOW_MENU=false
                        break ;;
            esac
      done
}


if [ $1 ] && [ $1='h' ]
then
      show_menu
else
      echo "😏 VAMOS TUNAR SEU FISH"
      echo "Vou te fazer algumas perguntas pessoais 👀..."

      read -p 'Nome da pasta para salvar os repositorios da Tamborine [default=Dev]: ' foldervar
      foldervar=${foldervar:-Dev}
      read -p "Caminho para a pasta $foldervar [default=$HOME]? " locationvar
      locationvar=${locationvar:-$HOME}
      MAIN_PATH="$locationvar/$foldervar/main"

      echo """
$MAIN_PATH
"""

      echo """
Hora de criar algumas 🐟 fish functions para facilitar sua vida

            Atalho para testar um arquivo apenas
      """

      read -p "🐟 Do libs/core/: [default=tcore] " corevar
      corevar=${corevar:-tcore}
      read -p "🐟 Do applications/account-manager/: [default=tam] " tamvar
      regrasvar=${tamvar:-tam}
      read -p "🐟 Do application/internet-banking/: [default=tib] " tibvar
      tibvar=${tibvar:-tib}
      read -p "🐟 Do applications/operation-system-server/: [default=tos] " tosvar
      tosvar=${tosvar:-tos}
      
      echo """function $corevar
            npx lerna run test:file --scope @tamborineapps/core --skip-nx-cache -- $MAIN_PATH/libs/core/test/$argv
      end
      """ >> $FISH_FUNCTION_PATH/$corevar.fish

      echo """function $tamvar
            npx lerna run test:file --scope @tamborineapps/account-manager --skip-nx-cache -- $MAIN_PATH/applications/account-manager/test/$argv
      end
      """ >> $FISH_FUNCTION_PATH/$tamvar.fish

      echo """function $tibvar
            npx lerna run test:file --scope @tamborineapps/internet-banking --skip-nx-cache -- $MAIN_PATH/applications/internet-banking/test/$argv
      end
      """ >> $FISH_FUNCTION_PATH/$tibvar.fish

      echo """function $tosvar
            npx lerna run test:file --scope @tamborineapps/operation-system-server --skip-nx-cache -- $MAIN_PATH/applications/operation-system-server/test/$argv
      end
      """ >> $FISH_FUNCTION_PATH/$tosvar.fish

      echo """function fish_greeting
            echo Alanzin te ama <3
      end
      """ >> $FISH_FUNCTION_PATH/fish_greeting.fish
      echo """
      🎉 Pronto 🎉
      """

      echo """
Ler o help [S/n]?
      """ 
      read -p "Resposta: [default=S] " answer
      answer=${answer:-S}

      if [ $answer = "S" ] || [ $answer = "s" ]
      then
            clear
            show_menu
      fi

      echo "${HELP_END}"
fi
