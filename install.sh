#!/bin/bash

USERNAME=$(whoami)

echo "📎 Configuration will be set for $USERNAME ($HOME)"
read -p 'Press enter to accept and ctrl + c to deny: '

repos_dir="$HOME/pro/src/github/tajpouria"
os_bootstrap_repo_dir="$repos_dir/os-bootstrap"
os_bootstrap_repo_http_url="https://github.com/tajpouria/os-bootstrap"

if [ ! -d "$os_bootstrap_repo_dir" ]
then
    echo "✨ Cloning OS bootstrap repository into '$repo_dir'"
    git clone "$os_boottsrap_repo_http_url" "$repo_dir"
    cd "$os_bootstrap_repo_dir"
else
   echo "✨ Pulling the OS bootstrap latest changes"
   cd "$os_bootstrap_repo_dir" 
   git pull origin master
fi

