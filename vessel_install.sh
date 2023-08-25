#!/bin/bash

NC="\033[0m"
B_BLUE="\033[7;34m"
B_BLU="\033[1;34m"
B_RED="\033[1;31m"
B_LRED="\033[7;31m"
B_WHI="\033[1;37m"
B_YELLOW="\033[1;33m"
B_GREL="\033[7;32m"
B_GRE="\033[1;32m"
BLUE="\033[0;34m"
BLU="\033[0;34m"
RED="\033[0;31m"
LRED="\033[0;31m"
WHI="\033[0;37m"
YELLOW="\033[0;33m"
GREL="\033[0;32m"
GRE="\033[0;32m"

Notify() {
    if [[ $2 ]]; then
        echo -e "$2 $1 $NC"
    else
        echo -e "$WHI $1 $NC"
    fi
}

NotifyInfo() {
    echo -e "$B_BLU $1 $NC"
}

NotifySuccess() {
    echo -e "$B_GRE $1 $NC"
}

NotifyError() {
    echo -e "$B_RED $1 $NC"
}

NotifyAsk() {
    echo -e "$B_YELLOW $1 $NC"
}

continuar() {
  NotifyAsk "Pressione ENTER para continuar"
  read -p "$*"
}

sudo apt install -y git && NotifySuccess "git instalado com sucesso" || NotifyError "Por algum motivo acima não foi possível instalar o git"

if [ ! -f "/home/$USER/.ssh/id_ed25519.pub" ]; then
  NotifyError "Chave id_ed25519.pub não encontrada no diretório /home/$USER/.ssh"
  NotifyInfo "Gerando nova chave ed25519..."

  ssh-keygen -t ed25519 -f /home/$USER/.ssh/id_ed25519 -q -N '' && NotifySuccess "Nova chave ed25519 gerada com sucesso!" || NotifyError "Por algum motivo acima não foi possível gerar a nova chave ed25519"

  cat /home/$USER/.ssh/id_ed25519.pub && NotifySuccess "Chave id_ed25519.pub gerada com sucesso, veja abaixo:\n" || NotifyError "Por algum motivo acima não foi possível capturar a nova chave id_ed25519.pub"

  NotifyInfo "Para continuar: 
  
  1. Adicione a chave SSH gerada acima ao seu repositório do Git2bis em https://git2bis.com.br/-/profile/keys;
  
  2. Depois acesse https://git2bis.com.br/-/profile/personal_access_tokens para gerar um novo token de acesso (OBS: NÃO ESQUEÇA DE SALVAR O TOKEN EM UM ARQUIVO DE TEXTO NA SUA MÁQUINA!!!); e,
  
  3. Depois adicione o token gerado na continuação da instalação do vessel."
fi

if [ ! -f "/home/$USER/.ssh/id_ecdsa.pub" ]; then
  NotifyError "Chave id_ecdsa.pub não encontrada no diretório /home/$USER/.ssh"
  NotifyInfo "Gerando nova chave ecdsa..."

  ssh-keygen -t ecdsa -f /home/$USER/.ssh/id_ecdsa -q -N '' && NotifySuccess "Nova chave ecdsa gerada com sucesso!" || NotifyError "Por algum motivo acima não foi possível gerar a nova chave ecdsa"

  cat /home/$USER/.ssh/id_ecdsa.pub && NotifySuccess "Chave id_ecdsa.pub gerada com sucesso, veja abaixo:\n" || NotifyError "Por algum motivo acima não foi possível capturar a nova chave id_ecdsa.pub"

  NotifyInfo "Para continuar: 
  
  1. Adicione a chave SSH gerada acima ao seu repositório do Git2bis em https://git2bis.com.br/-/profile/keys;
  
  2. Depois acesse https://git2bis.com.br/-/profile/personal_access_tokens para gerar um novo token de acesso (OBS: NÃO ESQUEÇA DE SALVAR O TOKEN EM UM ARQUIVO DE TEXTO NA SUA MÁQUINA!!!); e,
  
  3. Depois adicione o token gerado na continuação da instalação do vessel."
fi

NotifyAsk "Deseja clonar o repositório do Vessel? [S/n]"
read YoN
case "$YoN" in
  [sS]* )
    NotifyInfo "Clonando o repositório do Vessel..."
    git clone git@git2bis.com.br:bis2bis/m1/dev-tools/vessel.git --branch=salinet && NotifySuccess "Repositório do Vessel clonado com sucesso!" || NotifyError "Por algum motivo acima, não foi possível clonar o repositório do Vessel."
    ;;
  [nN]* )
    NotifyInfo "Não será clonado o repositório do Vessel."
    ;;
  * )
    NotifyError "Opção inválida."
    ;;
esac

cd vessel

./utils/install_requires.sh

./vessel.sh