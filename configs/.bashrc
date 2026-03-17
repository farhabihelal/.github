# ~/.bashrc — Farhabi Helal's Bash Configuration
# https://github.com/farhabihelal
# =============================================================================

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# =============================================================================
# Shell Options
# =============================================================================
shopt -s histappend       # Append to history, don't overwrite
shopt -s checkwinsize     # Update LINES and COLUMNS after each command
shopt -s globstar         # Enable ** glob pattern
shopt -s cdspell          # Correct minor spelling errors in cd
shopt -s autocd           # Type a directory name to cd into it

# =============================================================================
# History
# =============================================================================
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups   # Ignore duplicates and lines starting with space
HISTTIMEFORMAT="%F %T "            # Timestamp history entries

# Save history after each command
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }history -a"

# =============================================================================
# Colours & Prompt
# =============================================================================
# Enable colour support
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
fi

# Colour codes
_RESET='\[\e[0m\]'
_BOLD='\[\e[1m\]'
_GREEN='\[\e[32m\]'
_YELLOW='\[\e[33m\]'
_BLUE='\[\e[34m\]'
_CYAN='\[\e[36m\]'
_RED='\[\e[31m\]'

# Git branch in prompt
__git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
    echo " (${branch})"
}

# PS1: user@host:dir (git-branch) $
PS1="${_BOLD}${_GREEN}\u@\h${_RESET}:${_BLUE}\w${_YELLOW}\$(__git_branch)${_RESET}\$ "

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
# Local binaries
export PATH="${HOME}/.local/bin:${PATH}"

# Python user scripts
export PATH="${HOME}/.local/lib/python3/dist-packages:${PATH}" 2>/dev/null || true

# Cargo (Rust)
[[ -d "${HOME}/.cargo/bin" ]] && export PATH="${HOME}/.cargo/bin:${PATH}"

# Go
[[ -d "${HOME}/go/bin" ]] && export PATH="${HOME}/go/bin:${PATH}"

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
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -alFht'          # Sort by modification time
alias lS='ls -alFhS'          # Sort by size

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
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='htop'
alias ports='ss -tulnp'
alias path='echo -e "${PATH//:/\\n}"'
alias reload='source ~/.bashrc && echo "~/.bashrc reloaded"'

# =============================================================================
# Functions
# =============================================================================

# Create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1" || return 1; }

# Extract most archive formats
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"     ;;
            *.tar.gz)   tar xzf "$1"     ;;
            *.tar.xz)   tar xJf "$1"     ;;
            *.bz2)      bunzip2 "$1"     ;;
            *.rar)      unrar x "$1"     ;;
            *.gz)       gunzip "$1"      ;;
            *.tar)      tar xf "$1"      ;;
            *.tbz2)     tar xjf "$1"     ;;
            *.tgz)      tar xzf "$1"     ;;
            *.zip)      unzip "$1"       ;;
            *.7z)       7z x "$1"        ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Search for a string in files
fgrep_in() {
    grep -r --include="*.${2:-*}" "$1" .
}

# Quick HTTP server in current directory
serve() {
    local port="${1:-8000}"
    echo "Serving on http://localhost:${port}"
    python3 -m http.server "${port}"
}

# =============================================================================
# Completion
# =============================================================================
# Enable programmable completion
if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        # shellcheck source=/dev/null
        source /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        # shellcheck source=/dev/null
        source /etc/bash_completion
    fi
fi

# =============================================================================
# Local Overrides
# =============================================================================
# Source machine-specific config (not tracked in git)
[[ -f "${HOME}/.bashrc.local" ]] && source "${HOME}/.bashrc.local"
