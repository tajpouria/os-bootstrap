#! /bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
USERNAME=$(whoami)


echo "📎 Configuration will be set for $USERNAME ($HOME)"
read -p 'Press enter to accept and ctrl + c to deny: '


echo '✨ Upgrading apt packages'

# k8s
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
# gcloud
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
# virtualbox
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
# vagrant
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt update
sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates gnupg curl vim bison virtualbox vagrant unrar speedtest-cli neofetch

echo '✨ Installing apt packages'

sudo apt install -y git htop kubectl python3-pip parcellite docker-ce google-cloud-sdk

echo '✨ Installing drivers'

sudo ubuntu-drivers autoinstall


echo '✨ Installing snap packages'

sudo snap install brave bitwarden skype dbeaver-ce postman
sudo snap install code kontena-lens --classic


echo '✨ Installing other packages'

if ! command -v zsh &> /dev/null
then
  echo '🚀 Placing zsh'
  sudo apt install -y zsh
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  chsh -s $(which zsh)
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
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # load nvm
  read -p "📝 Enter your preferred node js version [stable]: " node_version
  node_version=${node_version:-'stable'}
  nvm install $node_version
  npm i -g yarn
fi

if ! command -v gvm &> /dev/null
then
  echo '🚀 Placing gvm'
  bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
  [[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm" # load gvm
  go_version=$(curl https://go.dev/VERSION\?m\=text)
  read -p "📝 Enter your preferred go version [$go_version]: " go_version
  go_version=${go_version:-"$go_version"}
  gvm install $go_version
  gvm use $go_version --default
fi

if ! command -v k3d &> /dev/null
then
  echo '🚀 Placing k3d'
  wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
fi

if ! command -v ghget &> /dev/null
then
  echo '🚀 Placing ghget'
  wget -O /tmp/ghget https://github.com/mohd-akram/ghget/raw/master/ghget
  sudo chmod +x /tmp/ghget
  sudo mv /tmp/ghget /usr/local/bin
fi

if ! command -v helm &> /dev/null
then
  echo '🚀 Placing helm'
  wget -O /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  bash /tmp/get_helm.sh
fi


echo '📌 Tunning configurations'

echo '🚀 Setting Git global config'
read -p "📝 Enter your Git username [tajpouria]: " GIT_USERNAME
GIT_USERNAME=${GIT_USERNAME:-'tajpouria'}
git config --global user.name $GIT_USERNAME
read -p "📝 Enter your Git email [tajpouria.dev@gmail.com]: " git_email
git_email=${git_email:-'tajpouria.dev@gmail.com'}
git config --global user.email $git_email
git config --global core.editor "vim"

echo '🚀 Generating a SSH key'
ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''

echo '🚀 Making projects directory'
mkdir -p "$HOME/pro/src/github/$git_username"

echo '🚀 Add your username to the docker group (You would need to log out and log back in so that your group membership is re-evaluated)'
sudo usermod -aG docker ${USER}


echo '🦴 Manual todos:'

declare -a manual_todos=(
  '📝 Enable Brave sync'
  '📝 Enable VSCode Setting sync'
  '📝 Add the ~/.ssh/id_rsa.pub to your Github account SSH key'
  '📝 initialize gcloud ($gcloud init)'
)
for t in "${manual_todos[@]}"; do
    echo $t
    read -p 'Press enter to continue: '
done


read -r -p "Do you want to reboot now? [Y/n]" response
response=${response,,} # toLower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
  reboot
fi
