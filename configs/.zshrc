# ~/.zshrc — Farhabi Helal's Zsh Configuration
# https://github.com/farhabihelal
# =============================================================================

# =============================================================================
# Oh My Zsh (optional — comment out if not using Oh My Zsh)
# =============================================================================
# export ZSH="${HOME}/.oh-my-zsh"
# ZSH_THEME="agnoster"
# plugins=(git docker python pip vscode)
# source "${ZSH}/oh-my-zsh.sh"

# =============================================================================
# Shell Options
# =============================================================================
setopt AUTO_CD              # cd by typing directory name
setopt CORRECT              # Spell-check commands
setopt HIST_IGNORE_DUPS     # Don't record duplicate history entries
setopt HIST_IGNORE_SPACE    # Don't record commands starting with a space
setopt HIST_VERIFY          # Show expanded history before running
setopt SHARE_HISTORY        # Share history between sessions
setopt EXTENDED_HISTORY     # Record timestamp in history
setopt AUTO_PUSHD           # Make cd push the old dir onto the stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicate dirs
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell

# =============================================================================
# History
# =============================================================================
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=20000

# =============================================================================
# Completion
# =============================================================================
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# =============================================================================
# Key Bindings (emacs-style)
# =============================================================================
bindkey -e
bindkey '^[[A' history-search-backward   # Up arrow: history search
bindkey '^[[B' history-search-forward    # Down arrow: history search
bindkey '^[[H' beginning-of-line         # Home
bindkey '^[[F' end-of-line               # End

# =============================================================================
# Prompt
# =============================================================================
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'

setopt PROMPT_SUBST
PROMPT='%B%F{green}%n@%m%f%b:%F{blue}%~%f%F{yellow}${vcs_info_msg_0_}%f%# '

# =============================================================================
# Environment Variables
# =============================================================================
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R --quit-if-one-screen --no-init'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# XDG Base Directories
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"

# =============================================================================
# PATH
# =============================================================================
export PATH="${HOME}/.local/bin:${PATH}"

# Homebrew (macOS / Linux)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Cargo (Rust)
[[ -d "${HOME}/.cargo/bin" ]] && export PATH="${HOME}/.cargo/bin:${PATH}"

# Go
[[ -d "${HOME}/go/bin" ]] && export PATH="${HOME}/go/bin:${PATH}"

# pyenv
if [[ -d "${HOME}/.pyenv" ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
fi

# =============================================================================
# Aliases — Navigation
# =============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# =============================================================================
# Aliases — Listing
# =============================================================================
# Use eza/exa if available, fall back to ls
if command -v eza &>/dev/null; then
    alias ls='eza --group-directories-first --icons'
    alias ll='eza -alFh --group-directories-first --icons --git'
    alias lt='eza -alFh --sort=modified --icons'
    alias lS='eza -alFh --sort=size --icons'
elif command -v exa &>/dev/null; then
    alias ls='exa --group-directories-first'
    alias ll='exa -alFh --group-directories-first --git'
else
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -alFh'
fi
alias la='ls -A'
alias l='ls -CF'

# =============================================================================
# Aliases — Safety
# =============================================================================
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# =============================================================================
# Aliases — Git
# =============================================================================
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias grb='git rebase'
alias gst='git stash'
alias gstp='git stash pop'

# =============================================================================
# Aliases — Python
# =============================================================================
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source .venv/bin/activate'

# =============================================================================
# Aliases — Docker
# =============================================================================
alias dk='docker'
alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dkimg='docker images'
alias dkrm='docker rm'
alias dkrmi='docker rmi'
alias dkc='docker compose'
alias dkcu='docker compose up -d'
alias dkcd='docker compose down'

# =============================================================================
# Aliases — System
# =============================================================================
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ports='ss -tulnp'
alias path='echo -e "${PATH//:/\\n}"'
alias reload='source ~/.zshrc && echo "~/.zshrc reloaded"'

# =============================================================================
# Functions
# =============================================================================

# Create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1" || return 1; }

# Extract archives
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"  ;;
            *.tar.gz)   tar xzf "$1"  ;;
            *.tar.xz)   tar xJf "$1"  ;;
            *.bz2)      bunzip2 "$1"  ;;
            *.rar)      unrar x "$1"  ;;
            *.gz)       gunzip "$1"   ;;
            *.tar)      tar xf "$1"   ;;
            *.zip)      unzip "$1"    ;;
            *.7z)       7z x "$1"     ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick HTTP server
serve() {
    local port="${1:-8000}"
    echo "Serving on http://localhost:${port}"
    python3 -m http.server "${port}"
}

# =============================================================================
# Plugins (manual, no plugin manager required)
# =============================================================================
# zsh-syntax-highlighting (install via package manager or manually)
[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
    && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
    && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# =============================================================================
# Local Overrides
# =============================================================================
# Source machine-specific config (not tracked in git)
[[ -f "${HOME}/.zshrc.local" ]] && source "${HOME}/.zshrc.local"
