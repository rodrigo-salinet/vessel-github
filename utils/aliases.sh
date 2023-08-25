#!/bin/bash

# verifica se a variável de ambiente V_PATH existe ou está vazia
if [ -z "$V_PATH" ]; then
    THIS_PATH=$(dirname "$0")

    cd ${THIS_PATH}
    cd ..

    V_PATH=$(pwd)
fi

# nesta seção são definidos os 'aliases' (atalhos) para os comandos shell no terminal

# incluir, editar ou excluir, conforme a necessidade

# os aliases abaixo foram definidos pelo autor, para facilitar o trabalho do usuário do vessel e são incluídos na inicialização do mesmo

# vessel interface
ALIAS[0]="alias vessel='${V_PATH}/vessel.sh'"

# executar `composer update` de qualquer pasta
ALIAS[2]="alias cup='${V_PATH}/utils/cup.sh'"

# executar `compass clean && compass compile` de qualquer pasta
ALIAS[3]="alias cccc='${V_PATH}/utils/cccc.sh'"

# inicializar containers pelo vessel
ALIAS[4]="alias vs1='${V_PATH}/vessel.sh s1'"

# zerar docker pelo vessel
ALIAS[5]="alias vzd1='${V_PATH}/vessel.sh zd1'"

# acessa container php pelo vessel m1
ALIAS[6]="alias vssh1='${V_PATH}/vessel.sh ssh1'"

# acessa container php pelo vessel m2
ALIAS[7]="alias vssh2='${V_PATH}/vessel.sh ssh2'"

# instala loja pelo vessel m1
ALIAS[8]="alias vi1='${V_PATH}/vessel.sh i1'"

# instala loja pelo vessel m2
ALIAS[9]="alias vi2='${V_PATH}/vessel.sh i2'"

# remove loja pelo vessel m1
ALIAS[10]="alias vr1='${V_PATH}/vessel.sh r1'"

# remove loja pelo vessel m2
ALIAS[11]="alias vr2='${V_PATH}/vessel.sh r2'"

# listagem de arquivos de qualquer pasta, inclusive em subpastas
ALIAS[12]="alias fif='ls -Rl | grep \"^-\"  -c'"

# (d)eletar pasta (v)ar de qualquer pasta
ALIAS[13]="alias dv='${V_PATH}/utils/dv.sh'"

# (d)eletar pasta (v)ar/(c)ache de qualquer pasta
ALIAS[14]="alias dvc='${V_PATH}/utils/dvc.sh'"

# executar (c)omposer (up)date (ssh) via container m(1)
ALIAS[15]="alias cupssh1='${V_PATH}/vessel.sh cu1'"

# executar (c)omposer (up)date (ssh) via container m(2)
ALIAS[16]="alias cupssh2='${V_PATH}/vessel.sh cu2'"

# (a)tivar (h)ints (f)ront/loja
ALIAS[17]="alias ahf='${V_PATH}/vessel.sh ahf'"

# (d)esativar (h)ints (f)ront/loja
ALIAS[18]="alias dhf='${V_PATH}/vessel.sh dhf'"

# (a)tivar (h)ints (b)ack/admin
ALIAS[19]="alias ahb='${V_PATH}/vessel.sh ahb'"

# (d)esativar (h)ints (b)ack/admin
ALIAS[20]="alias dhb='${V_PATH}/vessel.sh dhb'"

# executar (c)compass (c)lean e (c)ompass (c)ompile (ssh) m(1)
ALIAS[21]="alias ccccssh1='${V_PATH}/vessel.sh cc1'"

# executar (c)compass (c)lean e (c)ompass (c)ompile (ssh) m(2)
ALIAS[22]="alias ccccssh2='${V_PATH}/vessel.sh cc2'"

# (v)essel (d1)
ALIAS[23]="alias vd1='${V_PATH}/vessel.sh d1'"

# (v)essel (d2)
ALIAS[24]="alias vd2='${V_PATH}/vessel.sh d2'"

# adicionar e buscar repositório remoto da csd
ALIAS[25]="alias addcsdmaster='${V_PATH}/utils/addcsdmaster.sh'"

# executar git pull --rebase de qualquer pasta
ALIAS[26]="alias gpr='git pull --rebase'"

# executar jq (jquery | json) ao shell, de qualquer pasta
ALIAS[27]="alias jq='${V_PATH}/utils/jq'"

# executar (g)it pull && (g)it push de qualquer pasta
ALIAS[28]="alias gg='git pull && git push'"

# executar (g)it fetch && (g)it pull && (g)it push de qualquer pasta
ALIAS[29]="alias ggg='git fetch && git pull && git push'"

# adicionar repositório remoto e executar git cherry pick
ALIAS[30]="alias arcp='${V_PATH}/utils/addremote_cherrypick.sh'"

# comando "ports" para visualizar as portas utilizadas no linux
ALIAS[31]="alias ports='sudo watch ss -tulpn'"

# atalho para executar "code ." de qualquer pasta
ALIAS[32]="alias vs='code .'"

# a seguir são verificados e processados todos os aliases definidos acima
for i in "${ALIAS[@]}"
do
    if [ -a "$HOME/.zshrc" ]; then
        if [[ $(grep -F "$i" ~/.zshrc | wc -l) == 0 ]]; then
            NotifyInfo "Inserindo alias ($i) no arquivo .zshrc"
            echo -e "\n$i" >>~/.zshrc && NotifySuccess "Alias ($i) inserido com sucesso no arquivo .zshrc" || NotifyError "Por algum motivo acima não foi possível inserir o alias ($i) no arquivo .zshrc"
            zsh $V_PATH/utils/source_zshrc.sh
        fi
    fi

    if [ -a "$HOME/.bashrc" ]; then
        if [[ $(grep -F "$i" ~/.bashrc | wc -l) == 0 ]]; then
            NotifyInfo "Inserindo alias ($i) no arquivo .bashrc"
            echo -e "\n$i" >>~/.bashrc && NotifySuccess "Alias ($i) inserido com sucesso no arquivo .bashrc" || NotifyError "Por algum motivo acima não foi possível inserir o alias ($i) no arquivo .bashrc"
            sh $V_PATH/utils/source_bashrc.sh
        fi
    fi
done
