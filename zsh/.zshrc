# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search poetry z)

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $ZSH/oh-my-zsh.sh
source ~/.bash_profile
source ~/.zsh_profile

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# eval "$(starship init zsh)"

# pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# terraform
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/aponce1509/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/aponce1509/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/aponce1509/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/aponce1509/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/aponce1509/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/Users/aponce1509/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
source ~/.local/scripts/python_venv_activate
CONDA_BIN_PATH="$(conda info --base)/envs/$(basename $CONDA_DEFAULT_ENV)/bin"
PATH=$CONDA_BIN_PATH:$PATH

# Zoxide
eval "$(zoxide init zsh)"
# PATH="$PATH:/opt/homebrew"

# Tmuxifier
eval "$(tmuxifier init -)"
