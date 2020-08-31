# Autoload screen if we aren't in it.  (Thanks Fjord!)
#if [[ $STY = '' ]] then screen -xR; fi

# --------------------------------------
# zsh Modules
# --------------------------------------

autoload -Uz compinit promptinit zcalc zsh-mime-setup select-word-style colors
compinit
promptinit
colors
zsh-mime-setup

# --------------------------------------
# Options
# --------------------------------------

# why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_CD

# allows for complex for loop >> "for package in /home/us?r/**/*os"; do; done
setopt EXTENDED_GLOB

# Now we can pipe to multiple outputs!
setopt MULTIOS

# Spell check commands!  (Sometimes annoying)
setopt CORRECT

# This makes cd=pushd
setopt AUTO_PUSHD

# This will use named dirs when possible
setopt AUTO_NAME_DIRS

# If we have a glob this will expand it
setopt GLOB_COMPLETE
setopt PUSHD_MINUS

# No more annoying pushd messages...
# setopt PUSHD_SILENT

# blank pushd goes to home
setopt PUSHD_TO_HOME

# this will ignore multiple directories for the stack.  Useful?  I dunno.
setopt PUSHD_IGNORE_DUPS

# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
setopt RM_STAR_WAIT

# use magic (this is default, but it can't hurt!)
setopt ZLE

setopt NO_HUP

setopt VI

# only fools wouldn't do this ;-)
export EDITOR="vi"

setopt IGNORE_EOF

# If I could disable Ctrl-s completely I would!
setopt NO_FLOW_CONTROL

# beeps are annoying
setopt NO_BEEP

# Keep echo "station" > station from clobbering station
setopt NO_CLOBBER

# Case insensitive globbing
setopt NO_CASE_GLOB

# Be Reasonable!
setopt NUMERIC_GLOB_SORT

# I don't know why I never set this before.
setopt EXTENDED_GLOB

# hows about arrays be awesome?  (that is, frew${cool}frew has frew surrounding all the variables, not just first and last
setopt RC_EXPAND_PARAM

# --------------------------------------
# GIT
# --------------------------------------

# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_POST_BRANCH$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}


# Checks if working tree is dirty
parse_git_dirty() {
  local SUBMODULE_SYNTAX=''
  if [[ $POST_1_7_2_GIT -gt 0 ]]; then
        SUBMODULE_SYNTAX="--ignore-submodules=dirty"
  fi
  if [[ -n $(git status -s ${SUBMODULE_SYNTAX}  2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}


# Checks if there are commits ahead from remote
function git_prompt_ahead() {
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
  SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
  SHA=$(git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Get the status of the working tree
git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi
  echo $STATUS
}

#compare the provided version of git to the version installed and on path
#prints 1 if input version <= installed version
#prints -1 otherwise
function git_compare_version() {
  local INPUT_GIT_VERSION=$1;
  local INSTALLED_GIT_VERSION
  INPUT_GIT_VERSION=(${(s/./)INPUT_GIT_VERSION});
  INSTALLED_GIT_VERSION=($(git --version));
  INSTALLED_GIT_VERSION=(${(s/./)INSTALLED_GIT_VERSION[3]});

  for i in {1..3}; do
    if [[ $INSTALLED_GIT_VERSION[$i] -lt $INPUT_GIT_VERSION[$i] ]]; then
      echo -1
      return 0
    fi
  done
  echo 1
}

#this is unlikely to change so make it all statically assigned
POST_1_7_2_GIT=$(git_compare_version "1.7.2")

# ZSH_THEME_GIT_PROMPT_PREFIX="$fg_bold[green] ["
# ZSH_THEME_GIT_PROMPT_SUFFIX=" ] "
# ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"
# ZSH_THEME_GIT_PROMPT_DIRTY=" ✗"

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}%{$fg_no_bold[yellow]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[cyan]%}%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"
ZSH_THEME_GIT_PROMPT_POST_BRANCH="%{$reset_color%}:"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✗"

# --------------------------------------
# Variables
# --------------------------------------

export PATH="$PATH"
export RI="--format ansi"

declare -U path

#export LANG=en_US
if [[ -x `which most` ]]; then
  export PAGER=most
fi

if [[ -x `which gpg` ]]; then
  export GUILE_TLS_CERTIFICATE_DIRECTORY=/usr/local/etc/gnutls
fi

# RVM
if [[ -x `which rvm` ]]; then
  export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
  export GEM_HOME=$HOME/.gem
fi

# --------------------------------------
# External Files
# --------------------------------------

# Include external aliases
if [[ -d ~/.aliases ]]; then
    for f in ~/.aliases/*; do
      . $f
  done
fi

# Include dircolors file
if [ -f ~/.dircolors ]; then
    . ~/.dircolors
fi

autoload run-help
HELPDIR=~/zsh_help

# --------------------------------------
# Aliases
# --------------------------------------

#### ls
if [[ `uname|grep -i "Linux"` != "" ]]; then
  alias ls='ls --color=auto'
fi

#### Shell Conveniences

alias sz='source ~/.zshrc'
alias ez='vim ~/.zshrc'
alias mk=popd
alias lib='open ~/Library'

#### SSH


#### Misc.

if [[ -x `which tea_chooser` ]]; then
# I need to do this more elegantly...
    alias rt='cd /home/frew/bin/run/tea_chooser; ./randtea.rb'
fi

if [[ -f /usr/local/bin/git ]]; then
# I need to do this more elegantly...
    alias git='/usr/local/bin/git'
fi

# CPAN and sudo don't work together or something
if [[ -x `which perl` ]]; then
  alias cpan="su root -c 'perl -MCPAN -e \"shell\"'"
fi

# Maxima with line editing!  Now if only I could use zle...
if [[ -x `which maxima` && -x `which ledit` ]]; then
  alias maxima='ledit maxima'
fi

# Convenient.  Also works in Gentoo or Ubuntu
if [[ -x `which irb1.8` ]]; then
  alias irb='irb1.8 --readline -r irb/completion'
else
  alias irb='irb --readline -r irb/completion'
fi

# For some reason the -ui doesn't work on Ubuntu... I need to deal with that
# somehow...
if [[ -x `which unison` ]]; then
  alias un='unison -ui graphic -perms 0 default'
  alias un.='unison -ui graphic -perms 0 dotfiles'
fi

# fri is faster.
if [[ -x `which fri` ]]; then
  alias ri=fri
fi

# This is how you can see all of my passwords.
alias auth='view ~/.auth.des3'

# copy with a progress bar.
alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"

# save a few keystrokes when opening the learn sql database
if [[ -x `which psql` ]]; then
  alias lrnsql="psql learn_sql"
fi

# I use the commands like, every day now
alias seinr="sudo /etc/init.d/networking restart"
if [[ -x `which gksudo` && -x `which wlassistant` ]]; then
  alias gkw="gksudo wlassistant&"
fi

alias kgs='javaws http://files.gokgs.com/javaBin/cgoban.jnlp'

if [[ -x `which delish` ]]; then
  alias delish="noglob delish"
fi

alias tomes='screen -S tome -c /home/frew/.tomescreenrc'
alias mpfs='mplayer -fs -zoom'
alias mpns='mplayer -nosound'

if [[ -x /home/frew/personal/dino ]]; then
  dinoray=( /home/frew/personal/dino/* )
  alias dino='feh $dinoray[$RANDOM%$#dinoray+1]'
fi

# Move next only if `homebrew` is installed
if command -v brew >/dev/null 2>&1; then
    # Load rupa's z if installed
    [ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
fi

#### Globals...

alias -g G="| grep"
alias -g L="| less"

#### Suffixes...

if [[ -x `which abiword` ]]; then
  alias -s doc=abiword
fi
if [[ -x `which ooimpress` ]]; then
  alias -s ppt='ooimpress &> /dev/null '
fi

if [[ $DISPLAY = '' ]] then
  alias -s txt=vi
else
  alias -s txt=gvim
fi

# --------------------------------------
# Completion Stuff
# --------------------------------------

bindkey -M viins '\C-i' complete-word

# Faster! (?)
zstyle ':completion::complete:*' use-cache 1

# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete
zstyle ':completion:*' completer _expand _force_rehash _complete _approximate _ignored

# generate descriptions with magic.
zstyle ':completion:*' auto-description 'specify: %d'

# Don't prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Don't prompt for a huge list, menu it!
zstyle ':completion:*:default' menu 'select=0'

# Have the newer files last so I see them first
zstyle ':completion:*' file-sort modification reverse

# color code completion!!!!  Wohoo!
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"

unsetopt LIST_AMBIGUOUS
setopt  COMPLETE_IN_WORD

# Separate man page sections.  Neat.
zstyle ':completion:*:manuals' separate-sections true

# Egomaniac!
zstyle ':completion:*' list-separator 'fREW'

# complete with a menu for xwindow ids
zstyle ':completion:*:windows' menu on=0
zstyle ':completion:*:expand:*' tag-order all-expansions

# more errors allowed for large words and fewer for small words
zstyle ':completion:*:approximate:*' max-errors 'reply=(  $((  ($#PREFIX+$#SUFFIX)/3  ))  )'

# Errors format
zstyle ':completion:*:corrections' format '%B%d (errors %e)%b'

# Don't complete stuff already on the line
zstyle ':completion::*:(rm|vi):*' ignore-line true

# Don't complete directory we are already in (../here)
zstyle ':completion:*' ignore-parents parent pwd

zstyle ':completion::approximate*:*' prefix-needed false

# http://stackoverflow.com/questions/564648/zsh-tab-completion-for-cd
zstyle ':completion:*' special-dirs true

# --------------------------------------
# Key bindings
# --------------------------------------
zle -N select-word-style
select-word-style bash
bindkey -e

# Who doesn't want home and end to work?
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

# Incremental search is elite!
bindkey -M vicmd "/" history-incremental-search-backward
bindkey -M vicmd "?" history-incremental-search-forward

# Search based on what you typed in already
bindkey -M vicmd "//" history-beginning-search-backward
bindkey -M vicmd "??" history-beginning-search-forward

bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

bindkey "\eOP" run-help

# oh wow!  This is killer...  try it!
bindkey -M vicmd "q" push-line

# Ensure that arrow keys work as they should
bindkey '\e[A' up-line-or-history
bindkey '\e[B' down-line-or-history

bindkey '\eOA' up-line-or-history
bindkey '\eOB' down-line-or-history

bindkey '\e[C' forward-char
bindkey '\e[D' backward-char

bindkey '\eOC' forward-char
bindkey '\eOD' backward-char

bindkey -M viins 'jj' vi-cmd-mode
bindkey -M vicmd 'u' undo

# Rebind the insert key.  I really can't stand what it currently does.
bindkey '\e[2~' overwrite-mode

# Rebind the delete key. Again, useless.
bindkey '\e[3~' delete-char

bindkey -M vicmd '!' edit-command-output

# it's like, space AND completion.  Gnarlbot.
bindkey -M viins ' ' magic-space

# move shortcuts
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# --------------------------------------
# History Stuff
# --------------------------------------

# Where it gets saved
HISTFILE=$HOME/Dropbox/Soft/zsh/history

# Remember about 10 years worth of history (AWESOME)
SAVEHIST=200000
HISTSIZE=200000

# Don't overwrite, append!
setopt APPEND_HISTORY

# Write after each command
# setopt INC_APPEND_HISTORY

# Killer: share history between multiple shells
setopt SHARE_HISTORY

# If I type cd and then cd again, only save the last one
setopt HIST_IGNORE_DUPS

# Even if there are commands inbetween commands that are the same, still only save the last one
setopt HIST_IGNORE_ALL_DUPS

# Pretty    Obvious.  Right?
setopt HIST_REDUCE_BLANKS

# If a line starts with a space, don't save it.
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# When using a hist thing, make a newline show the change before executing it.
setopt HIST_VERIFY

# Save the time and how long a command ran
setopt EXTENDED_HISTORY

setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# --------------------------------------
# Prompt
# --------------------------------------
setopt PROMPT_SUBST

host_color=cyan
history_color=yellow
user_color=green
root_color=red
directory_color=yellow
error_color=red
jobs_color=green

host_prompt="%{$fg[$host_color]%}`whoami`%{$reset_color%}"

jobs_prompt1="%{$fg_bold[$jobs_color]%}(%{$reset_color%}"
jobs_prompt2="%{$fg[$jobs_color]%}%j%{$reset_color%}"
jobs_prompt3="%{$fg_bold[$jobs_color]%})%{$reset_color%}"
jobs_total="%(1j.${jobs_prompt1}${jobs_prompt2}${jobs_prompt3} .)"

history_prompt1="%{$fg_bold[$history_color]%}[%{$reset_color%}"
history_prompt2="%{$fg[$history_color]%}%h%{$reset_color%}"
history_prompt3="%{$fg_bold[$history_color]%}]%{$reset_color%}"
history_total="${history_prompt1}${history_prompt2}${history_prompt3}"

error_prompt1="%{$fg_bold[$error_color]%}<%{$reset_color%}"
error_prompt2="%{$fg[$error_color]%}%?%{$reset_color%}"
error_prompt3="%{$fg_bold[$error_color]%}>%{$reset_color%}"
error_total="%(?..${error_prompt1}${error_prompt2}${error_prompt3} )"

case "$TERM" in
  (screen)
    function precmd() { print -Pn "\033]0;S $TTY:t{%100<...<%~%<<}\007" }
  ;;
  (xterm)
    directory_prompt=""
  ;;
  (*)
    directory_prompt="%{$fg[$directory_color]%}%C%{$reset_color%}"
  ;;
esac

if [[ $USER == root ]]; then
    post_prompt="%{$fg_bold[$root_color]%}>%{$reset_color%}"
else
    post_prompt="%{$fg_bold[$directory_color]%}>%{$reset_color%}"
fi

#PS1="${host_prompt} ${jobs_total}${history_total} ${directory_prompt}${error_total}${post_prompt} "
PS1="${host_prompt}:${directory_prompt}$(git_prompt_info)${post_prompt} "
PROMPT='%{$fg[cyan]%}%B%n%b%{$reset_color%}:%{$fg[blue]%}%B%C%b%{$reset_color%} $(git_prompt_info)%{$fg[cyan]%}%(!.#.>)%{$reset_color%} '
RPROMPT='[%*]'

# --------------------------------------
# iTerm Tab and Title Customization
# --------------------------------------

function set_title_tab
{
  function settab
  {
    # file settab  -- invoked only if iTerm or Konsole is running
    #  Set iterm window tab to current directory and penultimate directory if the
    #  shell process is running.  Truncate to leave the rightmost $rlength characters.

    #  Use with functions settitle (to set iterm title bar to current directory)
    #  and chpwd
    if [[ $TERM_PROGRAM == iTerm.app && -z "$KONSOLE_DCOP_SESSION" ]];then

      # The $rlength variable prints only the 20 rightmost characters. Otherwise iTerm truncates
      # what appears in the tab from the left.
      # Chage the following to change the string that actually appears in the tab:

      tab_label="$PWD:h:t/$PWD:t"
      rlength="20"   # number of characters to appear before truncation from the left
      echo -ne "\e]1;${(l:rlength:)tab_label}\a"

    else

        # For KDE konsole tabs
        # Chage the following to change the string that actually appears in the tab:
        tab_label="$PWD:h:t/$PWD:t"
        rlength="20"   # number of characters to appear before truncation from the left

        # If we have a functioning KDE console, set the tab in the same way
        if [[ -n "$KONSOLE_DCOP_SESSION" && ( -x $(which dcop)  )  ]];then
          dcop "$KONSOLE_DCOP_SESSION" renameSession "${(l:rlength:)tab_label}"
        else
            : # do nothing if tabs don't exist
        fi

    fi
  }

  function settitle
  {
    # Function "settitle"  --  set the title of the iterm title bar. use with chpwd and settab
    # Change the following string to change what appears in the Title Bar label:
    title_lab=$HOST:r:r::$PWD

    # Prints the host name, two colons, absolute path for current directory
    # Change the title bar label dynamically:
    echo -ne "\e]2;[zsh]   $title_lab\a"
  }

  # Set tab and title bar dynamically using above-defined function
  function title_tab_chpwd { settab ; settitle }
    # Now we need to run it:
    title_tab_chpwd

  # Set tab or title bar label transiently to the currently running command
  if [[ "$TERM_PROGRAM" == "iTerm.app" ]];then
    function title_tab_preexec {  echo -ne "\e]1; $(history $HISTCMD | cut -b7- ) \a"  }
    function title_tab_precmd  { settab }
  else
    function title_tab_preexec {  echo -ne "\e]2; $(history $HISTCMD | cut -b7- ) \a"  }
    function title_tab_precmd  { settitle }
  fi

  typeset -ga preexec_functions
  preexec_functions+=title_tab_preexec

  typeset -ga precmd_functions
  precmd_functions+=title_tab_precmd

  typeset -ga chpwd_functions
  chpwd_functions+=title_tab_chpwd

}

####################
# call title tab method
set_title_tab

_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1  # Because we didn't really complete anything
}

# edit-command-output() {
#  BUFFER=$(eval $BUFFER)
#  CURSOR=0
# }
# zle -N edit-command-output


# --------------------------------------
# zsh Modules
# --------------------------------------

autoload -Uz compinit promptinit zcalc zsh-mime-setup
compinit
promptinit
zsh-mime-setup
