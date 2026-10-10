export XDG_CONFIG_HOME="$HOME/.config"

export DOTFILES="$HOME/.dotfiles"
export WORK_ENV="personal"
# export WORK_ENV="work"

export EDITOR=/opt/homebrew/bin/nvim
export DEFAULT_CONDA_ENV="default"

export PERSONAL_SECOND_BRAIN="/Users/aponce1509/repos/new_second_brain"
export WORK_SECOND_BRAIN="~/notes/"

if [[ $WORK_ENV = "work" ]]; then
  export SECOND_BRAIN_PATH=$WORK_SECOND_BRAIN
elif [[ $WORK_ENV = "personal" ]]; then
  export SECOND_BRAIN_PATH=$PERSONAL_SECOND_BRAIN
fi

export TMUXIFIER_LAYOUT_PATH="$HOME/.config/tmux/tmux-layouts"
