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

alias tree='tree -I ".git|node_modules"'

alias path='echo -e ${PATH//:/\\n}'

alias python='/opt/homebrew/bin/python3'

alias mini='ssh yazankittaneh@108.232.85.228'
alias air='export OPENAI_API_KEY=$OPENAI_API_KEY_ROUTE'
alias aime='export OPENAI_API_KEY=$OPENAI_API_KEY_PERSONAL'
alias openrouter='export OPENROUTER_API_KEY=$OPENROUTER_API_KEY'
alias claude='export ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY'
alias o='open .'
alias c='codium .'
alias cu='cursor .'
alias ks='echo -e "context: $(k config current-context)\nnamespace: $(k config view --minify --output jsonpath={..namespace})"'
alias kc='f (){ export KUBECONFIG=~/.kube/"$@".yaml; unset -f f; }; f'
alias kns='f(){ k config set-context --current --namespace="$@"; unset -f f; }; f'
complete -F __start_kubectl k