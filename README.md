<table>
  <tr>
    <td>
      <img src="./.github/blue-vessel.png">
    </td>
    <td>
      <h1 style="font-weight:bold">VESSEL GitHUB</h1>
      <div>
        <img src="https://img.shields.io/badge/version-1.0.0-orange.svg?&style=for-the-badge" alt="version">
        <img src="https://img.shields.io/badge/magento%20version-1.5.1%20composer-purple.svg?logo=magento&style=for-the-badge" alt="magento">
        <img src="https://img.shields.io/badge/status-stable-green.svg?logo=analytics&style=for-the-badge" alt="status">
      </div>
    </td>
  </tr>
  <tr>
    <td>
      <div>
        <h2>Shell Script</h2>
        <img src="./.github/shell-script-logo.jpg">
        <img src="./.github/oh-my-zsh.png">
      </div>
    </td>
  </tr>
  <tr>
    <td>
        <div>
          <h2>Versionamento</h2>
          <img src="./.github/git-github.png">
        </div>
    </td>
  </tr>
  <tr>
    <td>
        <div>
        <h2>Sistema Operacional</h2>
          <img src="./.github/logo-ubuntu.png">
        </div>
    </td>
  </tr>
</table>

<hr>

## Sobre

Vessel é um programa em feito com scritps `shell` para gerar o ambiente de desenvolvimento do `Magento 1` e `Magento 2`

<hr>

## Requisitos necessários

Ambiente local configurado para clonar repositórios no github.

[Acessar aqui para gerenciar o SSH](https://github.com/settings/keys)

[Acesse para gerenciar um token para usar no .env da raiz do vessel](https://github.com/settings/tokens).

<hr>

## Instalação

Para instalar, siga os passos abaixo:

1. Abra o terminal/shell;

2. Acesse o diretório onde será instalado, execute por exemplo `cd /home/$USER`;

3. Faça o download do arquivo <a href="https://github.com/rodrigo-salinet/vessel-github/vessel_install.sh" target="_blank">`vessel_install.sh`</a>;

  3.1. Clique com o botão direito em cima do link https://github.com/rodrigo-salinet/vessel-github/vessel_install.sh;
  3.2. Em seguida clique em `Salvar link como`;
  3.3. Salve na mesma pasta do passo 2.

4. Feito o download do arquivo, agora pelo terminal, já na pasta selecionada no passo 2, digite `./vessel_install.sh` e tecle ENTER;

5. Siga os passos de instalação e, caso ocorra algum erro, reporte todos os erros para rodrigo.salinet@gmail.com, que será providenciada uma solução.

<hr>

## Contribuição

<hr>

### Desenvolvimento

<hr>

**Dependencias:**

[Git](https://git-scm.com/)

[Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

[Docker Compose](https://docs.docker.com/compose/install/)

<hr>

### EXTRAS

  - [x] Fix containeres issues from local
  - [x] Mailhog Added into containers
  - [x] New menu features
  - [x] New devilbox features
  - [x] Aliases tips
  - [x] Fix remove host from /etc/hosts
  - [x] Prepared for vpn|homolog
  - [x] Fix datetime patterns from `utils/repair_aws_dump.sql`
  - [x] Packages auto-installation

<hr>

### TODO

- [x] Exibir versão atual e mais recente
- [x] Exibir quais containers de magento está funcionando
- [x] Atualizar o Vessel
- [x] Sair

- [x] Magento 1
  - [x] Containers
    - [x] Inicializar
    - [x] Pausar
    - [x] Excluir
    - [x] Acessar via ssh
    - [ ] Status
    - [ ] Logs
  - [x] Lojas
    - [ ] Listar
    - [x] Instalação completa
    - [x] Excluir
    - [ ] Atualizar
    - [x] Limpar cache
    - [x] Restore Dump
  - [ ] Modulos
    - [ ] Baixar
    - [ ] Listar
  - [x] Extras
    - [x] Zerar docker"
    - [x] Composer update"
    - [x] Compass compile"
    - [x] Remover Cookies"
    - [x] Desativar a opção Juntar Arquivos CSS"
    - [x] Desativar Recaptcha Ilitia"
    - [x] Desativar a opção Juntar Arquivos JS"
    - [x] Desativar a opção Sufix JS/CSS"
    - [x] Ativar Hints Front/Loja"
    - [x] Desativar Hints Front/Loja"
    - [x] Ativar Hints Back/Admin"
    - [x] Desativar Hints Back/Admin"
    - [x] Desativar Cache do Magento"

- [x] Magento 2
  - [x] Containers
    - [x] Inicializar
    - [x] Pausar
    - [ ] Excluir
    - [x] Acessar via ssh
    - [ ] Status
    - [ ] Logs
  - [x] Lojas
    - [x] Listar
    - [x] Instalar
    - [x] Instalar para desenvolvimento
    - [x] Instalar Sample Data
    - [x] Excluir
    - [x] Atualizar
    - [ ] Limpar cache
    - [x] Restore Dump
    - [x] Executavel Magento
    - [x] Composer

<hr>

Chaves recaptcha de todas as lojas bisws:

  chave do site: 6LfHLcseAAAAAIO0KyDyooxNa8vH86WayPD1hwEo
  chave secreta: 6LfHLcseAAAAAMuvoGTy43DYU1mGvHb5fTqSlRfc