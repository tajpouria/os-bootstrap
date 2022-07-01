export ZSH="/home/tajpouria/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    kubectl
)

# zsh-autosuggestions
bindkey '^ ' autosuggest-accept

# zsh-syntax-highlighting
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Auto complete
complete -o nospace -C /usr/bin/terraform terraform
complete -C /usr/local/bin/aws_completer aws

# Vagrant WSL access
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export PATH="$PATH:/mnt/c/Windows/System32"
export PATH="$PATH:/mnt/c/Program\ Files/Oracle/VirtualBox/"

fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}
fix_wsl2_interop
