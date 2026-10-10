die() {
    echo >&2 "$@"
    exit 1
}

saycb() {
    local output="/tmp/chatterbox.wav"
    chatterbox "$*" --output "$output" && afplay "$output"
}

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
