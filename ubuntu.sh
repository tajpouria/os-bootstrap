#! /bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
USERNAME=$(whoami)


echo "📎 Configuration will be set for $USERNAME ($HOME)"
read -p 'Press enter to accept and ctrl + c to deny: '


echo '✨ Upgrading apt packages'

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl

echo '✨ Installng apt packages'

sudo apt install -y zsh git htop kubectl

echo '✨ Installing drivers'

sudo ubuntu-drivers autoinstall


echo '✨ Installing snap packages'

sudo snap install brave bitwarden skype
sudo snap install code --classic


echo '✨ Installing other packages'

echo '🚀 Placing zsh'
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
sudo chsh -s $(which zsh)
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
cp "$SCRIPT_DIR/.zshrc" $HOME

echo '🚀 Placing nvm'
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
read -p "📝 Enter your preferred node js version [stable]: " node_version
node_version=${node_version:-'stable'}
nvm install $node_version
npm i -g yarn


echo '📌 Tunning configurations'

echo '🚀 Setting Git global config'
read -p "📝 Enter your Git username [tajpouria]: " GIT_USERNAME
GIT_USERNAME=${GIT_USERNAME:-'tajpouria'}
git config --global user.name $GIT_USERNAME
read -p "📝 Enter your Git email [tajpouria.dev@gmail.com]: " git_email
git_email=${git_email:-'tajpouria.dev@gmail.com'}
git config --global user.email $git_email
git config --list

echo '🚀 Generating a SSH key'
ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''

echo '🚀 Making projects directory'
mkdir -p "$HOME/pro/src/github/$git_username"


echo '🦴 Manual todos:'

declare -a manual_todos=(
  "📝 Enable NVIDIA (Performance Mode) from NVIDIA X Server Setting's Prime Profiles tab"
  '📝 Enable Brave sync'
  '📝 Enable VSCode Setting sync'
  '📝 Add the ~/.ssh/id_rsa.pub to your Github account SSH key'
)
for t in "${manual_todos[@]}"; do
    echo $t
    read -p 'Press enter to continue: '
done


read -r -p "Do you want to reboot now? [Y/n]" response
response=${response,,} # tolower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
  your-action-here
fi
