# Source common profile settings
source ~/.profile

# Source zsh-specific settings
if [ -f ~/.zshrc ]; then
  source ~/.zshrc
fi

# iTerm2 shell integration (zsh-specific)
if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi