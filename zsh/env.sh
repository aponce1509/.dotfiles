# export STOW_FOLDERS="bin,nvim,tmux,uwuntu,netflix,personal,i3,zsh,xkb"
export WORK_ENV="personal"
# export WORK_ENV="work"
# export STOW_FOLDERS="zellij,bin,alacritty,yabai,tmux,spacebar,zsh,powerlevel10k,nvim,starship"
export DOTFILES=$HOME/.dotfiles
export DEFAULT_CONDA_ENV="default"
export EDITOR=/opt/homebrew/bin/nvim

export PERSONAL_SECOND_BRAIN="/Users/aponce1509/repos/new_second_brain"
export WORK_SECOND_BRAIN="~/notes/"


if [[ $WORK_ENV = "work" ]]; then
  export SECOND_BRAIN_PATH=$WORK_SECOND_BRAIN
elif [[ $WORK_ENV = "personal" ]]; then
  export SECOND_BRAIN_PATH=$PERSONAL_SECOND_BRAIN
fi

export TMUXIFIER_LAYOUT_PATH="$HOME/.config/tmux/tmux-layouts"

# bun completions
[ -s "/Users/aponce1509/.bun/_bun" ] && source "/Users/aponce1509/.bun/_bun"

startMongo() {
    sudo systemctl start mongod
    sudo systemctl enable mongod
}

increaseWatchers() {
    sudo sysctl fs.inotify.max_user_watches=65536
    sudo sysctl -p
}

change_background() {
    dconf write /org/mate/desktop/background/picture-filename "'$HOME/dotfiles/backgrounds/$(ls ~/dotfiles/backgrounds | fzf)'"
}


die () {
    echo >&2 "$@"
    exit 1
}

addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

commitDotFiles() {
    pushd $DOTFILES
    pushd personal
    git add .
    git commit -m "automagic messaging from me in the past.  Have you checked up your butthole?"
    git push origin main
    popd
    git add .
    git commit -m "automagic messaging from me in the past.  Have you checked up your butthole?"
    git push origin main
    popd
}
