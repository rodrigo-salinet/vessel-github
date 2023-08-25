# Bashrc folder
#
# 1. This folder will be mounted to /etc/bashrc-devilbox.d
# 2. All files ending by *.sh will be sourced by bash automatically
#    for the devilbox and root user.
#


# Add your custom vimrc and always load it with vim.
# Also make sure you add vimrc to this folder.
alias vim='vim -u /etc/bashrc-devilbox.d/vimrc'

alias ports='sudo watch ss -tulpn'
alias gg='git pull && git push'
alias gpr='git pull --rebase'
alias ggg='git fetch && git pull && git push'
alias cup='composer update --no-interaction -vvv'
alias ci='composer install --no-interaction -vvv'
alias cgcl='composer global config --list'
