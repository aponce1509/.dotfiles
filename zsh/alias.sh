alias tmk="tmux kill-session"
alias tma="tmux attach"
alias tmxs="tmuxier load-session"
alias tms="tmux switch-client -t"
# alias cd="z"
# alias bat="batcat"

# bindkey -s ^f "zellij_sessionizer\n"
bindkey -s ^f "tmux-sessioner\n"
bindkey -s ^g "tmuxifier-session aponce\n"
bindkey -s ^n "tmuxifier-session\n"
bindkey -s ^o "clear\n"

# Eza
alias l="eza --icons --git -a"
alias lll="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"

alias la=tree
alias cat=bat

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# VIM
alias v="/opt/homebrew/bin/nvim"
alias lazy='cd ~/.local/share/nvim/lazy && nvim'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Wezterm
alias wzs="nohup wezterm start > /dev/null 2>&1 &"
