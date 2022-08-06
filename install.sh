#!/bin/bash

USERNAME=$(whoami)

echo "📎 Configuration will be set for $USERNAME ($HOME)"
read -p 'Press enter to accept and ctrl + c to deny: '

repo_dir="$HOME/pro/src/github/tajpouria"
os_bootsrap_repo_http_url="https://github.com/tajpouria/os-bootstrap"

if [ ! -d "$repo_dir" ]
then
    echo "✨ Cloning OS bootstrap repository into '$repo_dir'"
    mkdir -p "$repo_dir"
    git clone "$os_bootsrap_repo_http_url" "$repo_dir"
fi

