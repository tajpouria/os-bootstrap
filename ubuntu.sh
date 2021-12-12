#! /bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
USERNAME=$(whoami)


echo "📎 Configuration will be set for $USERNAME ($HOME)"
read -p 'Press enter to accept and ctrl + c to deny: '


echo '✨ Upgrading apt packages'

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

sudo apt update
sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl

echo '✨ Installing apt packages'

sudo apt install -y zsh git htop kubectl python3-pip parcellite docker-ce

echo '✨ Installing drivers'

sudo ubuntu-drivers autoinstall


echo '✨ Installing snap packages'

sudo snap install brave bitwarden skype
sudo snap install code --classic


echo '✨ Installing other packages'

if ! command -v zsh &> /dev/null
then
  echo '🚀 Placing zsh'
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  sudo chsh -s $(which zsh)
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  cp "$SCRIPT_DIR/.zshrc" $HOME
fi


if ! command -v conda &> /dev/null
then
  echo '🚀 Placing miniconda'
  wget -O /tmp/Miniconda3-latest-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  sudo chmod +x /tmp/Miniconda3-latest-Linux-x86_64.sh
  /tmp/Miniconda3-latest-Linux-x86_64.sh
fi


if ! command -v docker-compose &> /dev/null
then
  echo '🚀 Placing docker-compose'
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

if ! command -v node &> /dev/null
then
  echo '🚀 Placing nvm'
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  read -p "📝 Enter your preferred node js version [stable]: " node_version
  node_version=${node_version:-'stable'}
  nvm install $node_version
  npm i -g yarn
fi


echo '📌 Tunning configurations'

echo '🚀 Setting Git global config'
read -p "📝 Enter your Git username [tajpouria]: " GIT_USERNAME
GIT_USERNAME=${GIT_USERNAME:-'tajpouria'}
git config --global user.name $GIT_USERNAME
read -p "📝 Enter your Git email [tajpouria.dev@gmail.com]: " git_email
git_email=${git_email:-'tajpouria.dev@gmail.com'}
git config --global user.email $git_email

echo '🚀 Generating a SSH key'
ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''

echo '🚀 Making projects directory'
mkdir -p "$HOME/pro/src/github/$git_username"

echo '🚀 Add your username to the docker group (You would need to log out and log back in so that your group membership is re-evaluated)'
sudo usermod -aG docker ${USER}


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
  reboot
fi
