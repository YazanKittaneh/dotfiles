source ~/.profile
source ~/.bashrc

# Auto-resume the persistent OpenCode tmux session for interactive SSH logins.
if [[ $- == *i* ]] && [ -n "$SSH_CONNECTION" ] && [ -z "$TMUX" ] && [ -z "$NO_AUTO_TMUX" ] && command -v tmux >/dev/null 2>&1; then
  _opencode_tmux_bootstrap_session() {
    if ! tmux has-session -t opencode 2>/dev/null; then
      tmux new-session -d -s opencode -n opencode opencode
    fi

    if tmux list-windows -t opencode -F '#{window_name}' | grep -qx '__landing__'; then
      if [ "$(tmux list-panes -t opencode:__landing__ -F '#{pane_current_command}' | head -n 1)" != 'bash' ]; then
        tmux kill-window -t opencode:__landing__
      fi
    fi

    if ! tmux list-windows -t opencode -F '#{window_name}' | grep -qx '__landing__'; then
      tmux new-window -d -t opencode -n '__landing__' 'env OPENCODE_TERMIUS_LANDING=1 OPENCODE_RETURN_TARGET=opencode:1 bash -l'
    fi
  }

  _opencode_tmux_attach_window() {
    local target_window="$1"
    export _opencode_auto_tmux_attached=1
    _opencode_tmux_bootstrap_session
    exec tmux attach-session -t "$target_window"
  }

  case "${OPENCODE_AUTO_TMUX_MODE:-safe}" in
    off)
      ;;
    safe)
      _opencode_tmux_attach_window 'opencode:__landing__'
      ;;
    fast|*)
      _opencode_tmux_attach_window 'opencode:1'
      ;;
  esac
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yazankittaneh/google-cloud-sdk/path.bash.inc' ]; then . '/Users/yazankittaneh/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/yazankittaneh/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/yazankittaneh/google-cloud-sdk/completion.bash.inc'; fi

# Setting PATH for Python 2.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

if command -v brew >/dev/null 2>&1; then
  export GOROOT=$(brew --prefix go)/libexec
  export GOPATH=$HOME/go
  export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH
fi
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/yazankittaneh/.cache/lm-studio/bin"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.bash 2>/dev/null || :

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
. "$HOME/.cargo/env"
