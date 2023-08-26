#!/usr/bin/env bash

THIS_DIR=$(pwd)

source ${THIS_DIR}/libs/config.sh

NotifyError "ATENÇÃO!!!\n\n"

Notify "Os seguintes aplicativos, libs e pacotes serão instalados no seu computador:\n\n"

NotifyInfo "[ pv              ] -> aplicativo para mostrar o progresso de dump e descompactação de arquivo\n"
NotifyInfo "[ git             ] -> aplicativo para clonar repositórios das lojas e módulos\n"
NotifyInfo "[ ruby-full       ] -> aplicativo para executar comandos [gem]\n"
NotifyInfo "[ php5.6-dev      ] -> aplicativo para executar o debug/composer/etc\n"
NotifyInfo "[ compass         ] -> necessário para executar os comando [compass clean && compass compile] nas lojas\n"
NotifyInfo "[ snapd           ] -> necessário para instalação do vscode\n"
NotifyInfo "[ code            ] -> aplicativo para edição e debug dos códigos-fonte\n"
NotifyInfo "[ ca-certificates ] -> necessário para instalação do docker\n"
NotifyInfo "[ curl            ] -> necessário para baixar todos os pacotes necessários\n"
NotifyInfo "[ gnupg           ] -> necessário para instalação do docker\n"
NotifyInfo "[ lsb-release     ] -> necessário para instalação do docker\n"
NotifyInfo "[ docker          ] -> aplicativo de carregamento de containeres de serviços e configurações do mesmo\n"
NotifyInfo "[ docker-compose  ] -> aplicativo para carregar os containeres em lote dos arquivos *.yml\n"
NotifyInfo "[ composer        ] -> aplicativo para baixar e instalar os módulos das lojas\n"
NotifyInfo "[ codesniffer     ] -> aplicativo para utilizar na extensão phpcs do vscode\n"

Notify "Os seguintes aplicativos, libs e pacotes serão desinstalados do seu computador:\n\n"

NotifyInfo "[ mysql           ] -> será desinstalada qualquer versão do mysql na sua máquina local\n"
NotifyInfo "[ apache          ] -> será desinstalada qualquer versão do apache na sua máquina local\n"
NotifyInfo "[ nginx           ] -> será desinstalada qualquer versão do ngnx na sua máquina local\n"

NotifyAsk "Pressione s e ENTER para prosseguir ou n e ENTER para cancelar a instalação"

read SoN
case $SoN in
    s | S)
        NotifyInfo "Instalando os aplicativos necessários..."

        NotifyInfo "Instalando pv..."
        withSudo "apt install -y pv" && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Instalando git..."
        sudo apt install -y git && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        if [ -z "$GITHUB_USERNAME" ]; then
            cfgGithubUsernameNull
        fi
        NotifyInfo "Configurando git user.name local..."
        git config --global user.name ${GITHUB_USERNAME} && NotifySuccess "git user.name local configurado com sucesso!" || NotifyError "Por algum motivo acima não foi possível configurar o git user.name local."

        if [ -z "$GITHUB_USEREMAIL" ]; then
            cfgGithubUseremailNull
        fi
        NotifyInfo "Configurando git user.email local..."
        git config --global user.name ${GITHUB_USEREMAIL} && NotifySuccess "git user.email local configurado com sucesso!" || NotifyError "Por algum motivo acima não foi possível configurar o git user.email local."

        NotifyInfo "Instalando build-essential..."
        sudo apt install -y build-essential && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Instalando ruby-full..."
        sudo apt install -y ruby-full && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Instalando compass..."
        sudo gem install compass -f && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Instalando snapd..."
        sudo apt install -y snapd && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        #NotifyInfo "Instalando code..."
        #sudo snap install code --classic && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Desinstalando docker docker-engine docker.io containerd runc..."
        sudo apt remove -y docker docker-engine docker.io containerd runc && NotifySuccess "Aplicativos docker, docker-engine, docker.io, containerd e runc removidos com sucesso!" || NotifyError "Por algum motivo acima não foi possível remover os aplicativos docker, docker-engine, docker.io, containerd e runc, talvez porque ainda não tenham sido instalados. Veja log de erro acima acima."

        NotifyInfo "Atualizando repositórios..."
        sudo apt update && NotifySuccess "Atualização de repositórios bem sucedida!" || NotifyError "Por algum motivo acima não foi possível atualizar os repositórios."
        sudo apt upgrade -y && NotifySuccess "Apps atualizados com sucesso!" || NotifyError "Por algum motivo acima não foi possível atualizar os apps."

        NotifyInfo "Instalando ca-certificates..."
        sudo apt install -y ca-certificates && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Instalando curl..."
        sudo apt install -y curl && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Instalando gnupg..."
        sudo apt install -y gnupg && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Instalando lsb-release..."
        sudo apt install -y lsb-release && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Baixando docker..."
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Verificando o instalador do docker..."
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Atualizando repositórios..."
        sudo apt update && NotifySuccess "Atualização de repositórios bem sucedida!" || NotifyError "Por algum motivo acima não foi possível atualizar os repositórios."
        sudo apt upgrade -y && NotifySuccess "Apps atualizados com sucesso!" || NotifyError "Por algum motivo acima não foi possível atualizar os apps."

        NotifyInfo "Instalando docker-ce docker-ce-cli containerd.io..."
        sudo apt install -y docker-ce docker-ce-cli containerd.io && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Baixando docker-compose..."
        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Aplicando permissão de execução ao docker..."
        sudo chmod +x /usr/local/bin/docker-compose && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Instalando link ao docker..."
        sudo ln -s -f /usr/local/bin/docker-compose /usr/bin/docker-compose && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Adicionando repositório do php..."
        sudo add-apt-repository ppa:ondrej/php -y && NotifySuccess "Repositório adicionado com sucesso!" || NotifyError "Por algum motivo acima o repositório não pode ser adicionado."

        NotifyInfo "Atualizando repositório..."
        sudo apt update && NotifySuccess "Atualização de repositórios bem sucedida!" || NotifyError "Por algum motivo acima não foi possível atualizar os repositórios."
        sudo apt upgrade -y && NotifySuccess "Apps atualizados com sucesso!" || NotifyError "Por algum motivo acima não foi possível atualizar os apps."

        NotifyInfo "Instalando php5.6-dev..."
        sudo apt install -y php5.6-dev && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Instalando módulos para o php..."
        sudo apt install -y php5.6-cgi php5.6-cli php5.6-curl php5.6-imap php5.6-gd php5.6-mysql php5.6-pgsql php5.6-sqlite3 php5.6-mbstring php5.6-json php5.6-bz2 php5.6-mcrypt php5.6-xmlrpc php5.6-gmp php5.6-xsl php5.6-soap php5.6-xml php5.6-zip php5.6-dba php5.6-imagick php-codesniffer && NotifySuccess "Instalação bem sucedida!" || NotifyError "Por algum motivo acima a instalação falhou."

        NotifyInfo "Instalando composer..."
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && NotifySuccess "Composer copiado com sucesso." || NotifyError "Por algum motivo acima não foi possível copiar o composer."
        php composer-setup.php && NotifySuccess "Composer instalado com sucesso." || NotifyError "Por algum motivo acima a instalação falhou."
        php -r "unlink('composer-setup.php');" && NotifySuccess "Instalação do composer removida com sucesso." || NotifyError "Por algum motivo acima não foi possível remover a instalaçõa do composer."
        sudo mv composer.phar /usr/local/bin/composer && NotifySuccess "composer.phar renomeado para composer com sucesso." || NotifyError "Por algum motivo acima não foi possível renomear o composer.phar para composer."

        if [ -z $GITHUB_TOKEN ]; then
            cfgGithubTokenNull
        fi
        NotifyInfo "Configurando token github local..."
        composer global config github-token.github.com ${GITHUB_TOKEN} && NotifySuccess "Token github configurado com sucesso!" || NotifyError "Por algum motivo acima a configuração falhou."

        NotifyInfo "Configurando domains local..."
        composer global config github-domains "github.com" "github.com" && NotifySuccess "Domains configurado com sucesso!" || NotifyError "Por algum motivo acima a configuração falhou."

        NotifyInfo "Configurando http-basic local..."
        composer global config http-basic.repo.magento.com 4b5035e90eebe8bb3e77b7fec37f18e2 a5b4ed3838cb726d81054dd1ce528dde && NotifySuccess "http-basic configurado com sucesso!" || NotifyError "Por algum motivo acima a configuração falhou."

        NotifyInfo "Instalando phpcs via composer local..."
        composer global require "squizlabs/php_codesniffer=*" && NotifySuccess "Phpcs instalado via composer local com sucesso!" || NotifyError "Por algum motivo acima não foi possível instalar o phpcs via composer local."

        NotifyInfo "Desinstalando mysql..."
        sudo apt remove -y mysql* && NotifySuccess "mysql removido com sucesso!" || NotifyError "Por algum motivo acima não foi possível remover o mysql, talvez porque não tenha sido instalado, mas"

        NotifyInfo "Desinstalando apache..."
        sudo apt remove -y apache* && NotifySuccess "apache removido com sucesso!" || NotifyError "Por algum motivo acima não foi possível remover o apache, talvez porque não tenha sido instalado, mas"

        NotifyInfo "Desinstalando apache2..."
        sudo apt remove -y apache2* && NotifySuccess "apache2 removido com sucesso!" || NotifyError "Por algum motivo acima não foi possível remover o apache2, talvez porque não tenha sido instalado, mas"

        NotifyInfo "Desinstalando apache2-bin..."
        sudo apt remove -y apache2-bin* && NotifySuccess "apache2-bin removido com sucesso!" || NotifyError "Por algum motivo acima não foi possível remover o apache2-bin, talvez porque não tenha sido instalado, mas"

        NotifyInfo "Desinstalando nginx..."
        sudo apt remove -y nginx* && NotifySuccess "nginx removido com sucesso!" || NotifyError "Por algum motivo acima não foi possível remover o nginx, talvez porque não tenha sido instalado, mas"

        NotifyInfo "Aplicando permissão de usuário no docker..."
        sudo usermod -aG docker $USER && NotifySuccess "Usuário do docker configurado com sucesso!" || NotifyError "Por algum motivo acima não foi possível configurar o usuário do docker."

        NotifyInfo "Aplicando permissão de arquivo ao docker..."
        sudo chmod 777 /var/run/docker.sock && NotifySuccess "Permissão do docker aplicada com sucesso!" || NotifyError "Por algum motivo acima não foi possível aplicar a permissão do docker."

        NotifyInfo "Inicializando serviço do docker..."
        sudo systemctl start docker.service && NotifySuccess "Serviço do docker inicializado com sucesso!" || NotifyError "Por algum motivo acima não foi possível inicializar o docker."

        NotifyInfo "Inicializando serviço do containerd..."
        sudo systemctl start containerd.service && NotifySuccess "Serviço do containerd inicializado com sucesso!" || NotifyError "Por algum motivo acima não foi possível inicializar o containerd."

        NotifyInfo "Configurando containerd para (re)inicialização automática..."
        sudo systemctl enable containerd.service && NotifySuccess "Serviço do containerd habilitado na inicialização do sistema com sucesso!" || NotifyError "Por algum motivo acima não foi possível habilitar o containerd na inicialização do sistema."

        NotifyInfo "Configurando docker para (re)inicialização automática..."
        sudo systemctl enable docker.service && NotifySuccess "Serviço do docker habilitado na inicialização do sistema com sucesso!" || NotifyError "Por algum motivo acima não foi possível habilitar o docker na inicialização do sistema."

        NotifyInfo "Removendo apps, libs e pacotes desnecessários..."
        sudo apt autoremove -y && NotifySuccess "Remoção bem sucedida!" || NotifyError "Por algum motivo acima não foi possível executar a remoção."

        NotifyAsk "Confira abaixo algumas sugestões de extensões para o vscode:"

        Notify "https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-close-tag"
        Notify "https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag"
        Notify "https://marketplace.visualstudio.com/items?itemName=alefragnani.Bookmarks"
        Notify "https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer-2"
        Notify "https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker"
        Notify "https://marketplace.visualstudio.com/items?itemName=RandomFractalsInc.vscode-data-preview"
        Notify "https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug"
        Notify "https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker"
        Notify "https://marketplace.visualstudio.com/items?itemName=p1c2u.docker-compose"
        Notify "https://marketplace.visualstudio.com/items?itemName=formulahendry.docker-explorer"
        Notify "https://marketplace.visualstudio.com/items?itemName=waderyan.gitblame"
        Notify "https://marketplace.visualstudio.com/items?itemName=exelord.git-commits"
        Notify "https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory"
        Notify "https://marketplace.visualstudio.com/items?itemName=KnisterPeter.vscode-github"
        Notify "https://marketplace.visualstudio.com/items?itemName=howardzuo.vscode-gitk"
        Notify "https://marketplace.visualstudio.com/items?itemName=albizures.gitkit"
        Notify "https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens"
        Notify "https://marketplace.visualstudio.com/items?itemName=ecmel.vscode-html-css"
        Notify "https://marketplace.visualstudio.com/items?itemName=abusaidm.html-snippets"
        Notify "https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow"
        Notify "https://marketplace.visualstudio.com/items?itemName=ZainChen.json"
        Notify "https://marketplace.visualstudio.com/items?itemName=rafaelcgstz.magento-devsearch"
        Notify "https://marketplace.visualstudio.com/items?itemName=rafaelcgstz.magento-snippets"
        Notify "https://marketplace.visualstudio.com/items?itemName=cweijan.vscode-mysql-client2"
        Notify "https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug"
        Notify "https://marketplace.visualstudio.com/items?itemName=xdebug.php-pack"
        Notify "https://marketplace.visualstudio.com/items?itemName=bmewburn.vscode-intelephense-client"
        Notify "https://marketplace.visualstudio.com/items?itemName=zobo.php-intellisense"
        Notify "https://marketplace.visualstudio.com/items?itemName=ikappas.phpcs"
        Notify "https://marketplace.visualstudio.com/items?itemName=emallin.phpunit"
        Notify "https://marketplace.visualstudio.com/items?itemName=lkytal.pomodoro"
        Notify "https://marketplace.visualstudio.com/items?itemName=hoovercj.vscode-power-mode"
        Notify "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance"
        Notify "https://marketplace.visualstudio.com/items?itemName=ms-python.python"
        Notify "https://marketplace.visualstudio.com/items?itemName=chrmarti.regex"
        Notify "https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers"
        Notify "https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh"
        Notify "https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh-edit"
        Notify "https://marketplace.visualstudio.com/items?itemName=RolandGreim.sample-ext"
        Notify "https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync"
        Notify "https://marketplace.visualstudio.com/items?itemName=TabNine.tabnine-vscode"
        Notify "https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode"
        Notify "https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons"
        Notify "https://marketplace.visualstudio.com/items?itemName=redhat.vscode-xml"
        Notify "https://marketplace.visualstudio.com/items?itemName=DotJoshJohnson.xml"
        Notify "https://github.com/carloscuesta/gitmoji"

        NotifyAsk "Deseja instalar todas as extensões sugeridas acima?"
        read SONEXT
        case $SONEXT in
            s | S)
                NotifyInfo "Instalando extensões. Aguarde..."
                code --install-extension formulahendry.auto-close-tag
                code --install-extension formulahendry.auto-rename-tag
                code --install-extension alefragnani.Bookmarks
                code --install-extension CoenraadS.bracket-pair-colorizer-2
                code --install-extension streetsidesoftware.code-spell-checker
                code --install-extension RandomFractalsInc.vscode-data-preview
                code --install-extension vscjava.vscode-java-debug
                code --install-extension ms-azuretools.vscode-docker
                code --install-extension p1c2u.docker-compose
                code --install-extension formulahendry.docker-explorer
                code --install-extension waderyan.gitblame
                code --install-extension exelord.git-commits
                code --install-extension donjayamanne.githistory
                code --install-extension KnisterPeter.vscode-github
                code --install-extension howardzuo.vscode-gitk
                code --install-extension albizures.gitkit
                code --install-extension eamodio.gitlens
                code --install-extension ecmel.vscode-html-css
                code --install-extension abusaidm.html-snippets
                code --install-extension oderwat.indent-rainbow
                code --install-extension ZainChen.json
                code --install-extension rafaelcgstz.magento-devsearch
                code --install-extension rafaelcgstz.magento-snippets
                code --install-extension cweijan.vscode-mysql-client2
                code --install-extension xdebug.php-debug
                code --install-extension xdebug.php-pack
                code --install-extension bmewburn.vscode-intelephense-client
                code --install-extension zobo.php-intellisense
                code --install-extension ikappas.phpcs
                code --install-extension emallin.phpunit
                code --install-extension lkytal.pomodoro
                code --install-extension hoovercj.vscode-power-mode
                code --install-extension ms-python.vscode-pylance
                code --install-extension ms-python.python
                code --install-extension chrmarti.regex
                code --install-extension ms-vscode-remote.remote-containers
                code --install-extension ms-vscode-remote.remote-ssh
                code --install-extension ms-vscode-remote.remote-ssh-edit
                code --install-extension RolandGreim.sample-ext
                code --install-extension Shan.code-settings-sync
                code --install-extension TabNine.tabnine-vscode
                code --install-extension VisualStudioExptTeam.vscodeintellicode
                code --install-extension vscode-icons-team.vscode-icons
                code --install-extension redhat.vscode-xml
                code --install-extension DotJoshJohnson.xml
                code --install-extension seatonjiang.gitmoji-vscode
                NotifySuccess "Extensões instaladas com sucesso."
                ;;
            n | N)
                Notify "Ok. Continuando..."
                ;;
            *)
                NotifyError "Opção inválida"
                ;;
        esac
        ;;
    n | N)
        NotifyError "Instalação cancelada pelo usuário"
        exit 1
        ;;
    *)
        NotifyError "Opção inválida"
        exit 1
        ;;
esac
