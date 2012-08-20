# See following for more information: http://www.infinitered.com/blog/?p=10

# Identify OS and Machine -----------------------------------------
export OS=`uname -s | sed -e 's/  */-/g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export OSVERSION=`uname -r`; OSVERSION=`expr "$OSVERSION" : '[^0-9]*\([0-9]*\.[0-9]*\)'`
export MACHINE=`uname -m | sed -e 's/  */-/g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export PLATFORM="$MACHINE-$OS-$OSVERSION"
export LC_CTYPE=en_US.UTF-8
export HISTFILESIZE=1000000000
export HISTSIZE=1000000
# Note, default OS is assumed to be OSX



# Path ------------------------------------------------------------
if [ "$OS" = "darwin" ] ; then
  export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:$PATH  # OS-X Specific, with MacPorts and MySQL installed
  #export PATH=/opt/local/bin:/opt/local/sbin:$PATH  # OS-X Specific, with MacPorts installed
fi

if [ -d ~/bin ]; then
	export PATH=:~/bin:$PATH  # add your bin folder to the path, if you have it.  It's a good place to add all your scripts
fi

if [ -d ~/cl/bin ]; then
	export PATH=:~/cl/bin:$PATH  # add your bin folder to the path, if you have it
fi



# Load in .bashrc -------------------------------------------------
source ~/.bashrc



# Hello Messsage --------------------------------------------------
echo -e "Kernel Information: " `uname -smr`
echo -e "\\033[34m`bash --version`"
#echo -ne "${COLOR_GRAY}Uptime: "; uptime
echo -ne "\\033[34mUptime: "; uptime
echo -ne "\\033[34mServer time is: "; date
echo -ne "\\033[0m"



# Notes: ----------------------------------------------------------
# When you start an interactive shell (log in, open terminal or iTerm in OS X, 
# or create a new tab in iTerm) the following files are read and run, in this order:
#     profile
#     bashrc
#     .bash_profile
#     .bashrc (only because this file is run (sourced) in .bash_profile)
#
# When an interactive shell, that is not a login shell, is started 
# (when you run "bash" from inside a shell, or when you start a shell in 
# xwindows [xterm/gnome-terminal/etc] ) the following files are read and executed, 
# in this order:
#     bashrc
#     .bashrc

#export TERM=xterm-color
#alias ls='ls -G'
#alias ll='ls -hl'

#export CLICOLOR=1
#export LSCOLORS=ExFxCxDxBxegedabagacad

##
# Your previous /Users/johan/.bash_profile file was backed up as /Users/johan/.bash_profile.macports-saved_2011-09-06_at_18:08:45
##

# MacPorts Installer addition on 2011-09-06_at_18:08:45: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

