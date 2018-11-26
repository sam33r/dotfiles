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

export PATH="$HOME/emacs/src:$PATH:/usr/local/go/bin:$HOME/go/bin:$HOME/bin:$HOME/.local/bin:$HOME/bin:$HOME/dotfiles/utils" # Add local binaries.
export ANDROID_HOME=$HOME/Android/Sdk
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export VISUAL="vim"
export EDITOR="vim"

# For mail indexing
export MAILDIR=""
# To notify of new mails.
export NOTIFY_MAILDIR=""
# Used with gcalcli
export CALENDAR=""
# default browser
export BROWSER=google-chrome
# emacs version
export EMACS=""

# Local config
if [ -f ~/.profile.local ]; then
  . ~/.profile.local
fi

# hack for 256 color depth with fbterm
if [ "$TERM" = "linux" ]; then
echo -en "\e]P0222222" #black
echo -en "\e]P8222222" #darkgrey
echo -en "\e]P1803232" #darkred
echo -en "\e]P9982b2b" #red
echo -en "\e]P25b762f" #darkgreen
echo -en "\e]PA89b83f" #green
echo -en "\e]P3aa9943" #brown
echo -en "\e]PBefef60" #yellow
echo -en "\e]P4324c80" #darkblue
echo -en "\e]PC2b4f98" #blue
echo -en "\e]P5706c9a" #darkmagenta
echo -en "\e]PD826ab1" #magenta
echo -en "\e]P692b19e" #darkcyan
echo -en "\e]PEa1cdcd" #cyan
echo -en "\e]P7ffffff" #lightgrey
echo -en "\e]PFdedede" #white
FBTERM=1 exec fbterm
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

# For android studio
export _JAVA_AWT_WM_NONREPARENTING=1
