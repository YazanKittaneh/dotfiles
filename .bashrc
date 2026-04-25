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
. "$HOME/.cargo/env"

# OpenCode CLI
export PATH="/root/.opencode/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# OpenClaw Completion
source "/root/.openclaw/completions/openclaw.bash"

if [ -n "$TMUX" ] && [ -n "$OPENCODE_TERMIUS_LANDING" ]; then
  _opencode_landing_prompt_count=0

  (
    sleep 2
    if [ -z "${_opencode_landing_returned:-}" ]; then
      tmux switch-client -t "${OPENCODE_RETURN_TARGET:-opencode:1}" 2>/dev/null || true
    fi
  ) >/dev/null 2>&1 &

  _opencode_landing_return() {
    local exit_status="$?"

    if [ -n "${_opencode_landing_returned:-}" ]; then
      return "$exit_status"
    fi

    _opencode_landing_prompt_count=$((_opencode_landing_prompt_count + 1))

    if [ "${_termius_integration_installed:-}" = "yes" ] || [ "$_opencode_landing_prompt_count" -ge 2 ]; then
      _opencode_landing_returned=1
      tmux switch-client -t "${OPENCODE_RETURN_TARGET:-opencode:1}" 2>/dev/null || true
    fi

    return "$exit_status"
  }

  if [[ -n "$PROMPT_COMMAND" ]]; then
    PROMPT_COMMAND="_opencode_landing_return; $PROMPT_COMMAND"
  else
    PROMPT_COMMAND="_opencode_landing_return"
  fi
fi
