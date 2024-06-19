

# Remove /mnt/c/Users/cosgroma/.pyenv/pyenv-win from PATH
# export PATH=$(echo $PATH | sed -e 's/\/mnt\/c\/Users\/cosgroma\/.pyenv\/pyenv-win://g')

if [[ -e $CONDA_PYTHON ]]; then
    echo "Using conda python"
else
    # unset PYENV
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi
# export PATH="$PYENV_ROOT/versions/3.11.1/bin:$PATH"
