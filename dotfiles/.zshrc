#2 Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Defer non-prompt plugins so the first prompt is ready quickly.
ZINIT[COMPINIT_OPTS]=-C
zinit ice wait"0a" lucid blockf atload"zicompinit; zicdreplay"
zinit light zsh-users/zsh-completions
zinit ice wait"0b" lucid
zinit light zsh-users/zsh-autosuggestions
zinit ice wait"0b" lucid
zinit light Aloxaf/fzf-tab
zinit ice wait"0c" lucid
zinit light zsh-users/zsh-syntax-highlighting

# Add in snippets
zinit ice wait"0b" lucid
zinit snippet OMZP::git
zinit ice wait"0b" lucid
zinit snippet OMZP::sudo
zinit ice wait"0b" lucid atinit"setopt no_bg_nice"
zinit snippet OMZP::kubectl
zinit ice wait"0b" lucid
zinit snippet OMZP::kubectx
zinit ice wait"0b" lucid
zinit snippet OMZP::command-not-found

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
source "$HOME/.ben_scripts.sh"
alias ls='ls -al --color'
alias n='nvim'
alias vi='vim'
alias c='clear'
alias tf='tofu'

## SSH
alias sw='ssh agent1-vm-awseuw2'
alias inf='ssh infracage1-vm-awseuw2'
alias fpga='ssh fpgagent1-vm-awseuw2'

opi() {
  eval "$(op signin)" && export OP_SERVICE_ACCOUNT_TOKEN="$(op read "op://Infrastructure/52o5t4a2qcqtrdyn6z77uyg2eu/credential")"
}

codex() {
  local arg

  for arg in "$@"; do
    case "$arg" in
      --profile|-p|--profile=*)
        command codex "$@"
        return
        ;;
    esac
  done

  if [[ -r "$HOME/.codex/alerts.config.toml" ]]; then
    command codex --profile alerts "$@"
  else
    command codex "$@"
  fi
}

## GIT
alias gcm='git commit -m'
alias gs='git status'
alias gpo='git push origin'
alias gp='git pull'
alias gd='git diff | delta'

alias bash='/opt/homebrew/bin/bash'

alias dir='eza --long --icons --git -a'
alias tree='eza --long --icons --git --tree -a --git-ignore'

# PATH
export PATH=$PATH:$HOME/.local/bin 
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin/
export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-$HOME/.npm-global}"
path=("$NPM_CONFIG_PREFIX/bin" $path)
typeset -U path PATH

# VARS
export EDITOR=nvim
export TERM=xterm-256color
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TEST=true

unset COLORTERM # breaks k9s if set

# Shell integrations

if [ "$(uname)" = "Linux" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    eval "$(fzf --zsh)"
fi

if [ -z "$TMUX" ]; then
  # exec tmux new-session -A -s workspace
fi

export GOPATH="$HOME/go"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# MOTD: surface a curated cheat or a tldr example
if [[ -o interactive ]]; then
  autoload -Uz add-zsh-hook
  _zshrc_print_motd_once() {
    add-zsh-hook -d precmd _zshrc_print_motd_once
    getCheatSheet 2>/dev/null
    unfunction _zshrc_print_motd_once
  }
  add-zsh-hook precmd _zshrc_print_motd_once
fi

eval "$(zoxide init zsh)"

# Agent shell snapshots capture functions and aliases but not zoxide's hook arrays.
unalias cd 2>/dev/null
cd() {
  if [[ ${chpwd_functions[(Ie)__zoxide_hook]:-0} -eq 0 ]]; then
    __zoxide_cd "$@"
  else
    __zoxide_z "$@"
  fi
}
