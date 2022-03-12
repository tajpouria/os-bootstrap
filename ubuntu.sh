#! /bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
USERNAME=$(whoami)
IS_WSL=0

echo "📎 Configuration will be set for $USERNAME ($HOME)"
read -p 'Press enter to accept and ctrl + c to deny: '

if [[ -n "$WSL_DISTRO_NAME" ]]; then
  echo 'WSL detected.'
  read -p 'Press enter to accept and ctrl + c to deny: '
  IS_WSL=1
fi

echo '✨ Installing apt packages'

sudo apt update
sudo apt upgrade -y
sudo apt install -y git htop python3-pip apt-transport-https ca-certificates gnupg curl nvim unrar speedtest-cli software-properties-common bison ipcalc

# k8s
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt install -y kubectl

# gcloud
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt install -y google-cloud-sdk

# terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install -y terraform

# ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update
sudo apt install ngrok

if [ $IS_WSL -eq 0 ]; then
  # docker
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
  sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt install docker-ce
fi

if [ $IS_WSL -eq 0 ]; then
  # virtualbox
  echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
  sudo apt install -y virtualbox
fi

if [ $IS_WSL -eq 0 ]; then
  # vagrant
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt install -y vagrant
fi

if [ $IS_WSL -eq 0 ]; then
  sudo apt install -y parcellite
fi

if [ $IS_WSL -eq 0 ]; then
  echo '✨ Installing drivers'
  sudo ubuntu-drivers autoinstall
fi

if [ $IS_WSL -eq 0 ]; then
  echo '✨ Installing Snap packages'
  sudo snap install brave bitwarden skype dbeaver-ce postman yq
  sudo snap install code --classic
  sudo snap install kontena-lens --classic
fi

echo '✨ Installing other packages'

if ! command -v zsh &>/dev/null; then
  echo '🚀 Placing zsh'
  sudo apt install -y zsh
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  cp "$SCRIPT_DIR/.zshrc" $HOME
  chsh -s $(which zsh)
fi

if ! command -v tmux &>/dev/null; then
  echo '🚀 Placing tmux'
  sudo apt install -y tmux
  cp "$SCRIPT_DIR/.tmux.con" $HOME
fi

if ! command -v node &>/dev/null; then
  echo '🚀 Placing nvm'
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # load nvm
  read -p "📝 Enter your preferred node js version [stable]: " node_version
  node_version=${node_version:-'stable'}
  nvm install $node_version
  npm i -g yarn
fi

if ! command -v gvm &>/dev/null; then
  echo '🚀 Placing gvm'
  bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
  [[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm" # load gvm
  go_version=$(curl https://go.dev/VERSION\?m\=text)
  read -p "📝 Enter your preferred go version [$go_version]: " go_version
  go_version=${go_version:-"$go_version"}
  gvm install $go_version
  gvm use $go_version --default
fi

if ! command -v k3d &>/dev/null; then
  echo '🚀 Placing k3d'
  wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
fi

if ! command -v ghget &>/dev/null; then
  echo '🚀 Placing ghget'
  wget -O /tmp/ghget https://github.com/mohd-akram/ghget/raw/master/ghget
  sudo chmod +x /tmp/ghget
  sudo mv /tmp/ghget /usr/local/bin
fi

if ! command -v helm &>/dev/null; then
  echo '🚀 Placing helm'
  wget -O /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  bash /tmp/get_helm.sh
fi

if [ $IS_WSL -eq 0 ]; then
  if ! command -v docker-compose &>/dev/null; then
    echo '🚀 Placing docker-compose'
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  fi
fi

echo '📌 Tunning configurations'

read -r -p "Do you want to set git configuration? [Y/n]" response
response=${response,,} # toLower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
  echo '🚀 Setting Git global config'
  read -p "📝 Enter your Git username [tajpouria]: " GIT_USERNAME
  GIT_USERNAME=${GIT_USERNAME:-'tajpouria'}
  git config --global user.name $GIT_USERNAME
  read -p "📝 Enter your Git email [tajpouria.dev@gmail.com]: " git_email
  git_email=${git_email:-'tajpouria.dev@gmail.com'}
  git config --global user.email $git_email
  git config --global core.editor "nvim"
fi

read -r -p "Do you want to a new SSH key pair? [Y/n]" response
response=${response,,} # toLower
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
  echo '🚀 Generating a SSH key'
  ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
fi

echo '🚀 Making projects directory'
mkdir -p "$HOME/pro/src/github/$git_username"

echo '🚀 Add your username to the docker group (You would need to log out and log back in so that your group membership is re-evaluated)'
sudo usermod -aG docker ${USER}

echo '✨ Cleaning apt packages'

sudo apt autoremove

echo '🦴 Manual todos:'

declare -a manual_todos=(
  '📝 Enable Performance mode'
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
