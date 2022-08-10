if status is-interactive
    set -Ux PYENV_ROOT $HOME/.pyenv
    set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
end

pyenv init - | source

# ". ./venv/bin/activate.fish" problem
set -e _OLD_FISH_PROMPT_OVERRIDE 
set -e _OLD_VIRTUAL_PYTHONHOME
set -e _OLD_VIRTUAL_PATH
