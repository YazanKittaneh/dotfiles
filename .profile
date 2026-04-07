# History settings
export HISTSIZE=1000000
export HISTFILESIZE=1000000000

# Reattach to the existing tmux session on interactive SSH logins.
case "$-" in
  *i*)
    if [ -n "$SSH_CONNECTION" ] && [ -z "$TMUX" ] && command -v tmux >/dev/null 2>&1; then
      tmux attach-session || exec tmux new-session
    fi
    ;;
esac

# Editor settings
export EDITOR="emacs -nw"
export LESSCHARSET="utf-8"

# GTK settings
export GTK_IM_MODULE=xim

# Base PATH setup - order matters!
# Local user binaries first
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.bin" ]; then
  export PATH="$HOME/.bin:$PATH"
fi

# Homebrew setup (macOS or Linux)
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew" ]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
  export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
  export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
fi

# Programming languages
# Go
if command -v brew &> /dev/null && brew --prefix go &> /dev/null; then
  export GOROOT=$(brew --prefix go)/libexec
  export GOPATH=$HOME/go
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Bun
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH=$BUN_INSTALL/bin:$PATH
fi

# Node.js (NVM)
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
fi

# Java (Jabba)
if [ -d "$HOME/.jabba" ]; then
  source "$HOME/.jabba/jabba.sh"
fi

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.bash.inc" ]; then
  source "$HOME/google-cloud-sdk/path.bash.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.bash.inc" ]; then
  source "$HOME/google-cloud-sdk/completion.bash.inc"
fi

# LM Studio CLI
if [ -d "$HOME/.cache/lm-studio" ]; then
  export PATH="$PATH:$HOME/.cache/lm-studio/bin"
fi

# Load environment variables
if [ -f "$HOME/.env" ]; then
  source "$HOME/.env"
fi

. "$HOME/.cargo/env"
