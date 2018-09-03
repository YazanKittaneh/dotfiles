if [[ `uname` == 'Linux' ]]; then
  alias cls="clear"
elif [[ `uname` == 'Darwin' ]]; then
  alias cls="clear && node -e \"process.stdout.write('\\u001b]1337;ClearScrollback\\u0007')\""
fi

alias l="ls -cl -hp --time-style=long-iso --group-directories-first --color=auto"

alias cd1="cd .."
alias cd2="cd ../../"
alias cd3="cd ../../../"
alias cd4="cd ../../../../"
alias cd5="cd ../../../../../"

start() { nohup $1 &> /dev/null & disown; }
alias updates="sudo apt-get update && sudo apt-get dist-upgrade && sudo apt autoremove && if [ -x \"$(command -v snap)\" ]; then sudo snap refresh; fi;"
alias chrome="nohup /usr/bin/google-chrome-stable --remote-debugging-port=9222 &> ~/.chrome.nohup.out & disown"

if [[ `uname` == 'Darwin' ]]; then
  alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
  alias hidehidden="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
  alias rds="find . -name \"*.DS_Store\" -type f -delete"
fi

alias path='echo -e ${PATH//:/\\n}'

if [[ `uname` == 'Darwin' ]]; then
  alias flushdns='sudo dscacheutil -flushcache ; sudo killall -HUP mDNSResponder'
fi

alias vmlist='VBoxManage list vms'
alias vmstart='VBoxManage startvm --type headless'
vmstop() { VBoxManage controlvm $1 poweroff; }

alias base64-enc="openssl enc -base64"
alias base64-dec="openssl enc -base64 -d"

alias rsa='echo -e "\nEncrypt, Decrypt, Sign and Verify using the OpenSSL RSA util.\n\nYou can use stdin and stdout, or the -in and -out arguments to specify paths.\n\nExamples:\n rsa-enc -inkey key.pub.pem\n rsa-dec -inkey key.pem\n rsa-sign -inkey key.pem\n rsa-verify -inkey key.pem"'
alias rsa-enc="openssl rsautl -encrypt -pubin"   # -inkey key.pub.pem
alias rsa-dec="openssl rsautl -decrypt"          # -inkey key.pem
alias rsa-sign="openssl rsautl -sign"            # -inkey key.pem
alias rsa-verify="openssl rsautl -verify"        # -inkey key.pem
