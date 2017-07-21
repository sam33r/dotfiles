# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$PATH:$HOME/go/bin" # Add local Go binaries.

export VISUAL="vim"
export EDITOR="vim"

# For mail indexing
export MAILDIR=""
# To notify of new mails.
export NOTIFY_MAILDIR=""
# Used with gcalcli
export CALENDAR=""
# default browser
export BROWSER=w3m
# emacs version
export EMACS=""

# Local config
if [ -f ~/.profile.local ]; then
  . ~/.profile.local
fi

# if test -f $HOME/.gpg-agent-info && \
#     kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
#     GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info | cut -c 16-`
# else
#     # No, gpg-agent not available; start gpg-agent
#     eval `gpg-agent --daemon --no-grab  --log-file /tmp/gpg-agent.log`
# fi
# export GPG_TTY=`tty`
# export GPG_AGENT_INFO
