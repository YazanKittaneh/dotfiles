export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

if [[ $OSTYPE == 'darwin'* ]]; then
  alias l="ls -cl -hp --color=always"
else
  alias l="ls -cl -hp --time-style=long-iso --group-directories-first --color=always"
fi

if [ -f "$HOME/.env" ]; then
    . "$HOME/.env"
fi


if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi


if [ -f .bash_aliases ]; then
  source .bash_aliases
fi

if [ -f .bash_prompt ]; then
  source .bash_prompt
fi

if [ -f .gitcompletion.bash ]; then
  source .gitcompletion.bash
fi

if [ -f .tmux.conf ]; then
  tmux source ~/dotfiles/.tmux.conf
fi



# Node.js version manager
if [ -d .nvm ]; then
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

alias ll="l -a"

alias c1="cd .."
alias c2="cd ../../"
alias c3="cd ../../../"
alias c4="cd ../../../../"
alias c5="cd ../../../../../"

if [[ $OSTYPE != 'darwin'* ]]; then
  alias open="xdg-open"
fi
start() { nohup $1 &> /dev/null & disown; }

alias tree='tree -I ".git|node_modules"'

alias path='echo -e ${PATH//:/\\n}'

alias python='/opt/homebrew/bin/python3'

alias mini='ssh yazankittaneh@99.31.77.12'
alias air='export OPENAI_API_KEY=$OPENAI_API_KEY_ROUTE'
alias aime='export OPENAI_API_KEY=$OPENAI_API_KEY_PERSONAL'
alias openrouter='export OPENROUTER_API_KEY=$OPENROUTER_API_KEY'
alias sweet='export ANTHROPIC_API_KEY=SWEET_OPENAI_API_KEY'
alias addy='pipx run aider-chat --sonnet'
alias o='open .'
alias c='codium .'
alias cu='cursor .'
alias ks='echo -e "context: $(k config current-context)\nnamespace: $(k config view --minify --output jsonpath={..namespace})"'
alias kc='f (){ export KUBECONFIG=~/.kube/"$@".yaml; unset -f f; }; f'
alias kns='f(){ k config set-context --current --namespace="$@"; unset -f f; }; f'

# bun completions
[ -s "/Users/yazankittaneh/.bun/_bun" ] && source "/Users/yazankittaneh/.bun/_bun"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/yazankittaneh/.cache/lm-studio/bin"
# End of LM Studio CLI section


# OpenCode CLI
export PATH="/root/.opencode/bin:$PATH"

# OpenClaw Completion
source "/root/.openclaw/completions/openclaw.zsh"


if [[ -n "$TMUX" && -n "$OPENCODE_TERMIUS_LANDING" ]]; then
  typeset -g _opencode_landing_prompt_count=0

  {
    sleep 2
    if [[ -z "${_opencode_landing_returned:-}" ]]; then
      tmux switch-client -t "${OPENCODE_RETURN_TARGET:-opencode:1}" 2>/dev/null || true
    fi
  } >/dev/null 2>&1 &

  _opencode_landing_return() {
    local exit_status=$?

    if [[ -n "${_opencode_landing_returned:-}" ]]; then
      return $exit_status
    fi

    _opencode_landing_prompt_count=$((_opencode_landing_prompt_count + 1))

    if [[ "${_termius_integration_installed:-}" == "yes" || "$_opencode_landing_prompt_count" -ge 2 ]]; then
      typeset -g _opencode_landing_returned=1
      tmux switch-client -t "${OPENCODE_RETURN_TARGET:-opencode:1}" 2>/dev/null || true
    fi

    return $exit_status
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _opencode_landing_return
fi



[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
