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

export VISUAL="vim"
export EDITOR="vim"
export NOTIFY_MAILDIR="$HOME/mail/samahuja@google.com/@Me/new"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export VISUAL="vim"
export EDITOR="vim"
# To notify of new mails.
export NOTIFY_MAILDIR=""
# Used with gcalcli
export CALENDAR=""
# default browser
export BROWSER=w3m


# Local config
if [ -f ~/.profile.local ]; then
  . ~/.profile.local
fi