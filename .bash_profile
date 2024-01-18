source ~/.profile
source ~/.bashrc

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yazankittaneh/google-cloud-sdk/path.bash.inc' ]; then . '/Users/yazankittaneh/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/yazankittaneh/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/yazankittaneh/google-cloud-sdk/completion.bash.inc'; fi

# Setting PATH for Python 2.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH
