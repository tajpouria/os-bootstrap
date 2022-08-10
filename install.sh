#!/bin/bash

USERNAME=$(whoami)

echo "📎 Configuration will be set for $USERNAME ($HOME)"
read -p 'Press enter to accept and ctrl + c to deny: '

repos_dir="$HOME/pro/src/github/tajpouria"
os_bootstrap_repo_dir="$repos_dir/os-bootstrap"
os_bootstrap_repo_http_url="https://github.com/tajpouria/os-bootstrap"

if [ ! -d "$os_bootstrap_repo_dir" ]; then
    echo "✨ Cloning OS bootstrap repository into '$repos_dir'"
    mkdir -p "$repos_dir"
    cd "$repos_dir"
    git clone "$os_bootstrap_repo_http_url"
    cd "$os_bootstrap_repo_dir"
else
    echo "✨ Pulling the OS bootstrap latest changes"
    cd "$os_bootstrap_repo_dir"
    git pull origin master
fi

echo "✨ Source python venv & Install prerequisite packages"
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

echo "✨ Running the install playbook"
ansible-playbook ./main.yaml --ask-become-pass
