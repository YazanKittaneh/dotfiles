# Source common profile settings
source ~/.profile

# Source bash-specific settings
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# iTerm2 shell integration (bash-specific)
if [ -e "${HOME}/.iterm2_shell_integration.bash" ]; then
  source "${HOME}/.iterm2_shell_integration.bash"
fi

# Added by Antigravity
export PATH="/Users/yazankittaneh/.antigravity/antigravity/bin:$PATH"
