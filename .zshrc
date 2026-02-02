# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Remove unwanted Oh My Zsh aliases
unalias gk

# Aliases (zsh-compatible)
if [[ $OSTYPE == 'darwin'* ]]; then
  alias l="ls -cl -hp -G"  # -G enables colors on macOS
else
  alias l="ls -cl -hp --time-style=long-iso --group-directories-first --color=always"
fi

alias ll="l -a"

# Directory navigation
alias c1="cd .."
alias c2="cd ../../"
alias c3="cd ../../../"
alias c4="cd ../../../../"
alias c5="cd ../../../../../"

# Platform-specific open command
if [[ $OSTYPE != 'darwin'* ]]; then
  alias open="xdg-open"
fi

# Start function for background processes
start() { nohup $1 &> /dev/null & disown; }

# Kill process on specific port
killport() {
  if [ -z "$1" ]; then
    echo "Usage: killport <port>"
    return 1
  fi
  local pids=$(lsof -ti:$1)
  if [ -z "$pids" ]; then
    echo "No process found on port $1"
    return 1
  fi
  echo "$pids" | xargs kill -9 && echo "Killed process(es) on port $1: $pids"
}
alias kp='killport'

# Common aliases
alias tree='tree -I ".git|node_modules"'
alias path='echo -e ${PATH//:/\\n}'
alias python='/opt/homebrew/bin/python3'

# SSH shortcuts
alias mini='ssh yazankittaneh@99.31.77.12'

# API key management
alias air='export OPENAI_API_KEY=$OPENAI_API_KEY_ROUTE'
alias aime='export OPENAI_API_KEY=$OPENAI_API_KEY_PERSONAL'
alias openrouter='export OPENROUTER_API_KEY=$OPENROUTER_API_KEY'
alias claudekey='export ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY'
alias sweet='export ANTHROPIC_API_KEY=$SWEET_OPENAI_API_KEY'

# Development tools
alias addy='pipx run aider-chat --sonnet'
alias o='open .'
alias c='codium .'
alias cu='cursor .'
alias cy='claude --dangerously-skip-permissions'


# Kubernetes aliases
alias ks='echo -e "context: $(kubectl config current-context)\nnamespace: $(kubectl config view --minify --output jsonpath={..namespace})"'
alias kc='f (){ export KUBECONFIG=~/.kube/"$@".yaml; unset -f f; }; f'
alias kns='f(){ kubectl config set-context --current --namespace="$@"; unset -f f; }; f'

# Tmux configuration
if [ -f ~/.tmux.conf ]; then
  tmux source ~/dotfiles/.tmux.conf 2>/dev/null
fi

# NVM - use specific version if .nvmrc exists
if [ -d "$HOME/.nvm" ]; then
  if [ -f .nvmrc ]; then
    nvm use 2>/dev/null || nvm use default
  else
    nvm use default 2>/dev/null
  fi
fi

# Java - use specific version
if [ -d "$HOME/.jabba" ]; then
  jabba use openjdk@1.14.0 2>/dev/null
fi

# Python environment management (pyenv)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIPENV_VENV_IN_PROJECT="1"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# Load environment variables if not already loaded
if [ -f "$HOME/.env" ]; then
  source "$HOME/.env"
fi 

alias cc='claude converse --dangerously-skip-permissions'
alias ccy='claude converse --dangerously-skip-permissions'
alias vy='vt cy'

# Claude Code - Bitbucket Integration (added 2025-12-09)
# Note: Set BITBUCKET_APP_PASSWORD in ~/.env to avoid exposing secrets
export BITBUCKET_USERNAME="ykittaneh@paychex.com"
if [ -n "$BITBUCKET_APP_PASSWORD" ]; then
  export BITBUCKET_APP_PASSWORD="$BITBUCKET_APP_PASSWORD"
fi
export BITBUCKET_WORKSPACE="surepayroll"

# GPG configuration
export GPG_TTY=$(tty)

alias claude-mem='bun "/Users/ykittaneh/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'

# opencode
export PATH=/Users/ykittaneh/.opencode/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
