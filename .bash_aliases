if [[ $OSTYPE == 'darwin'* ]]; then
  alias l="ls -cl -hp --color=always"
else
  alias l="ls -cl -hp --time-style=long-iso --group-directories-first --color=always"
fi

if [ -f "$HOME/.env" ]; then
    . "$HOME/.env"
fi


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

alias tree='tree -I ".git|node_modules"'

alias path='echo -e ${PATH//:/\\n}'

# Python - use homebrew on macOS, system on Linux
if [[ $OSTYPE == 'darwin'* ]]; then
  alias python='/opt/homebrew/bin/python3'
else
  alias python='/usr/bin/python3'
fi

alias mini='ssh yazankittaneh@99.31.77.12'
alias air='export OPENAI_API_KEY=$OPENAI_API_KEY_ROUTE'
alias aime='export OPENAI_API_KEY=$OPENAI_API_KEY_PERSONAL'
alias openrouter='export OPENROUTER_API_KEY=$OPENROUTER_API_KEY'
alias claudekey='export ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY'
alias sweet='export ANTHROPIC_API_KEY=$SWEET_OPENAI_API_KEY'
alias addy='pipx run aider-chat --sonnet'
alias o='open .'
alias c='codium .'
alias cu='cursor .'
alias cy='claude --dangerously-skip-permissions'
alias ks='echo -e "context: $(k config current-context)\nnamespace: $(k config view --minify --output jsonpath={..namespace})"'
alias kc='f (){ export KUBECONFIG=~/.kube/"$@".yaml; unset -f f; }; f'
alias kns='f(){ k config set-context --current --namespace="$@"; unset -f f; }; f'
alias cy='claude --dangerously-skip-permissions'
alias ccy='claude converse --dangerously-skip-permissions'
alias vy='vt cy'