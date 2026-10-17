# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# TEST(revert: git checkout zsh/.zshrc) — p10k instant prompt disabled while testing starship
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="" # TEST(revert: git checkout zsh/.zshrc) — theme disabled while testing starship
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search poetry z)

# TEST: p10k prompt config disabled while testing starship. Revert: git checkout zsh/.zshrc
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $ZSH/oh-my-zsh.sh
source ~/.bash_profile
source ~/.zsh_profile

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# TEST: starship enabled while testing starship. Revert: git checkout zsh/.zshrc
eval "$(starship init zsh)"

# starship transient prompt: once a command is submitted, its prompt collapses
# to just "❯ cmd"; the full prompt only shows on the line being edited.
_starship_transient_line_init() {
  emulate -L zsh
  [[ $CONTEXT == start ]] || return 0
  while true; do
    zle .recursive-edit
    local -i ret=$?
    [[ $ret == 0 && $KEYS == $'\4' ]] || break # Ctrl+d on empty line
    [[ -o ignore_eof ]] || exit 0
  done
  local saved_prompt=$PROMPT saved_rprompt=$RPROMPT
  PROMPT='%B%F{#cba6f7}❯%f%b '
  RPROMPT=''
  zle .reset-prompt
  PROMPT=$saved_prompt RPROMPT=$saved_rprompt
  if (( ret )); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}
zle -N zle-line-init _starship_transient_line_init

# terraform
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide
eval "$(zoxide init zsh)"

# tmuxifier
eval "$(tmuxifier init -)"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# python: brew python@3.14 is the default (unversioned python/pip)
export PATH="/opt/homebrew/opt/python@3.14/libexec/bin:$PATH"

source ~/.local/scripts/python_venv_activate

# uv and uvx completions
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# keybindings
bindkey -s ^o "clear\n"

# opencode
export PATH=/Users/aponce1509/.opencode/bin:$PATH
