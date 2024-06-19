
# >>> conda initialize >>>
CONDA_PYTHON=true
conda_version="anaconda3"
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/$conda_version/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/$conda_version/etc/profile.d/conda.sh" ]; then
        . "$HOME/$conda_version/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/$conda_version/bin:$PATH"
    fi
fi
unset __conda_setup