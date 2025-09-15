if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi


if [ -f ~/dotfiles/.bash_aliases ]; then
  source ~/dotfiles/.bash_aliases
fi

if [ -f ~/dotfiles/.bash_prompt ]; then
  source ~/dotfiles/.bash_prompt
fi

if [ -f ~/dotfiles/.gitcompletion.bash ]; then
  source ~/dotfiles/.gitcompletion.bash
fi

if [ -f ~/dotfiles/.tmux.conf ]; then
  tmux source ~/dotfiles/.tmux.conf
fi

# Node.js version manager
if [ -d ~/.nvm ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  if [ -f .nvmrc ]; then
    nvm use
  else
    nvm use default
  fi
fi

# Java version manager
if [ -d "$HOME/.jabba" ]; then
  source "$HOME/.jabba/jabba.sh"
  jabba use openjdk@1.14.0
fi
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/yazankittaneh/.cache/lm-studio/bin"

alias claude="/Users/yazankittaneh/.claude/local/claude"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"
