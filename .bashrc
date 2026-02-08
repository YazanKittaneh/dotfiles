# Auto-start tmux for interactive shells
if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [[ $- == *i* ]] && [ -z "$VSCODE_RESOLVING_ENVIRONMENT" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
  tmux new-session -A -s main
fi

# Ghostty shell integration
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

# Source bash aliases
if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

# Source bash prompt customization
if [ -f ~/.bash_prompt ]; then
  source ~/.bash_prompt
fi

# Git completion for bash
if [ -f ~/.gitcompletion.bash ]; then
  source ~/.gitcompletion.bash
fi

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

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.cargo/env"

# opencode
export PATH=/Users/yazankittaneh/.opencode/bin:$PATH

# pnpm
export PNPM_HOME="/Users/yazankittaneh/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
