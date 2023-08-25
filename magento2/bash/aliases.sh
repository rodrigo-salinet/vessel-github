# Bashrc folder
#
# 1. This folder will be mounted to /etc/bashrc-devilbox.d
# 2. All files ending by *.sh will be sourced by bash automatically
#    for the devilbox and root user.
#


# Add your custom vimrc and always load it with vim.
# Also make sure you add vimrc to this folder.
alias vim='vim -u /etc/bashrc-devilbox.d/vimrc'

alias bm='php bin/magento'
alias m2uc='bm setup:upgrade && bm setup:di:compile'
alias m2u='bm setup:upgrade'
alias m2c='bm setup:di:compile'
alias m2cc='bm cache:clean && bm cache:flush'
alias m2d='bm setup:static-content:deploy pt_BR en_US -f'
alias ports='sudo watch ss -tulpn'
alias gg='git pull && git push'
alias gpr='git pull --rebase'
alias ggg='git fetch && git pull && git push'
alias m22f='bm module:disable Magento_TwoFactorAuth -f --clear-static-content && bm setup:di:compile'
alias m2csp='bm module:disabe Magento_Csp --clear-static-content && bm setup:di:compile'
alias m2r='bm indexer:reindex'
alias cup='composer update -vvv'
alias ci='composer install -vvv'
# Desativar módulos não nativos
alias dmnn='php bin/magento module:status | grep -v Magento | grep -v List | grep -v None | grep -v -e '^$'| xargs php bin/magento module:disable'
alias dm='bm module:disable $1 --clear-static-content && bm setup:di:compile'
alias tsl='cd var/log && tail -n 100 system.log && cd ../..'
alias tel='cd var/log && tail -n 100 exception.log && cd ../..'
alias rmvar='bin/magento cache:flush && rm -rf var/generation/* var/cache/* var/report/* pub/static/frontend/* pub/static/adminhtml/* var/page_cache/* var/di/* generated/* && bin/magento setup:upgrade'
alias sadm="mysql -h mysql -uroot -pmagento -f \${PWD/*\//} -e 'UPDATE admin_user SET password = CONCAT(SHA2(\"Admin1234\", 256), \":xxxxxxxx:1\") WHERE username = \"admin\";'"
alias ...='.. && ..'
alias cgcl='composer global config --list'
