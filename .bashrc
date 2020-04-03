# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
PATH="/home/arthur/scripts:/usr/local/sbin:/usr/local/bin:/usr/local/games:/usr/sbin:/usr/bin:/usr/games:/sbin:/bin:/snap/bin:/home:/home/arthur/sdk/flutter/bin:/opt/android-studio/bin"
export PATH

JAVA_HOME="/opt/android-studio/jre"
export JAVA_HOME

alias asdfjkl="fortune | cowsay"
alias f="fzf"
alias ft="fzf-tmux"
alias cl="echo -e '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n'"
alias gits="git status"
alias d=docker


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# expot PATH
# [[ ":$PATH:" != *":/home/arthur/scripts:"* ]] && PATH="/home/arthur/scripts:${PATH}"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#
#       Start custom prompt (ezprompt.net)
#


# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		#echo -e ":\033[38;5;13m${BRANCH}${STAT}\033[38;5;15m"
		# echo -e ":\033[38;5;13m${BRANCH}${STAT}\e[0m"
		echo "${BRANCH}${STAT}"
	else
		echo "-"
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

#export PS1="[\[\e[33m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]]>\[\e[35m\]\`parse_git_branch\`\[\e[m\]  " \[\e[35m\] -- \[\e[m\]
BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`

# export PS1="[\[$(tput sgr0)\]\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]|\[$(tput sgr0)\]\[\033[38;5;10m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]|\[$(tput sgr0)\]\[\033[38;5;14m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]|\[\033[38;5;13m\]\`parse_git_branch\`\[\e[m\]]> "
export PS1="[\[$(tput sgr0)\]\[\033[38;5;14m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]|\[\033[38;5;13m\]\`parse_git_branch\`\[\e[m\]]> \[$(tput sgr0)\]"



#
#       End custom prompt
#


#       CUSTOM LS

alias ls='ls --color'
LS_COLORS=""

# attributes defines
text_bold="1"
text_underlined="4"


# color defines
color_def="39"
color_light_red="91"
color_light_yellow="93"
color_light_green="92"
color_light_cyan="96"
color_light_blue="94"
color_light_magenta="95"
color_light_gray="37"
color_red="31"
color_yellow="33"
color_green="32"
color_cyan="36"
color_blue="34"
color_magenta="35"
color_dark_gray="90"

# 		CUSTOM LS | color resets
LS_COLORS=$LS_COLORS:"di=0:" # main directories
LS_COLORS=$LS_COLORS:"ow=0:" # User made Directories
LS_COLORS=$LS_COLORS:"ln=0:" # symbolic links
LS_COLORS=$LS_COLORS:"fi=0:" # File
LS_COLORS=$LS_COLORS:"ex=0:" # Executable File
LS_COLORS=$LS_COLORS:"so=0:" # Socket file
LS_COLORS=$LS_COLORS:"bd=0:" # Block (buffered) special file
LS_COLORS=$LS_COLORS:"cd=0:" # Character (unbuffered) special file
LS_COLORS=$LS_COLORS:"or=0:" # Symbolic link pointing to non-existent file (orphan)
LS_COLORS=$LS_COLORS:"rs=0:"
LS_COLORS=$LS_COLORS:"pi=0:"
LS_COLORS=$LS_COLORS:"mh=0:"
LS_COLORS=$LS_COLORS:"pi=0:"
LS_COLORS=$LS_COLORS:"so=0:"
LS_COLORS=$LS_COLORS:"do=0:"
LS_COLORS=$LS_COLORS:"mi=0:"
LS_COLORS=$LS_COLORS:"su=0:"
LS_COLORS=$LS_COLORS:"sg=0:"
LS_COLORS=$LS_COLORS:"ca=0:"
LS_COLORS=$LS_COLORS:"tw=0:"
LS_COLORS=$LS_COLORS:"st=0:"

#		CUSTOM LS | generic color declarations
LS_COLORS=$LS_COLORS:"ow=$color_light_green:" 	# User made Directories
LS_COLORS=$LS_COLORS:"di=$color_green:" 				# main directories
LS_COLORS=$LS_COLORS:"ex=$color_light_yellow" 			# Executable File
LS_COLORS=$LS_COLORS:"ln=$color_light_magenta:" 		# symbolic links
LS_COLORS=$LS_COLORS:"or=$color_red:" 					# Symbolic link pointing to non-existent file (orphan)
#LS_COLORS=$LS_COLORS:"fi=$color_light_yellow:" 					# File

# man page color
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# 		CUSTOM LS | file specific color declarations
# LS_COLORS=$LS_COLORS:"*.tar=01;31:"
# LS_COLORS=$LS_COLORS:"*.tgz=01;31:"
# LS_COLORS=$LS_COLORS:"*.arc=01;31:"
# LS_COLORS=$LS_COLORS:"*.arj=01;31:"
# LS_COLORS=$LS_COLORS:"*.taz=01;31:"
# LS_COLORS=$LS_COLORS:"*.lha=01;31:"
# LS_COLORS=$LS_COLORS:"*.lz4=01;31:"
# LS_COLORS=$LS_COLORS:"*.lzh=01;31:"
# LS_COLORS=$LS_COLORS:"*.lzma=01;31:"
# LS_COLORS=$LS_COLORS:"*.tlz=01;31:"
# LS_COLORS=$LS_COLORS:"*.txz=01;31:"
# LS_COLORS=$LS_COLORS:"*.tzo=01;31:"
# LS_COLORS=$LS_COLORS:"*.t7z=01;31:"
# LS_COLORS=$LS_COLORS:"*.zip=01;31:"
# LS_COLORS=$LS_COLORS:"*.z=01;31:"
# LS_COLORS=$LS_COLORS:"*.Z=01;31:"
# LS_COLORS=$LS_COLORS:"*.dz=01;31:"
# LS_COLORS=$LS_COLORS:"*.gz=01;31:"
# LS_COLORS=$LS_COLORS:"*.lrz=01;31:"
# LS_COLORS=$LS_COLORS:"*.lz=01;31:"
# LS_COLORS=$LS_COLORS:"*.lzo=01;31:"
# LS_COLORS=$LS_COLORS:"*.xz=01;31:"
# LS_COLORS=$LS_COLORS:"*.zst=01;31:"
# LS_COLORS=$LS_COLORS:"*.tzst=01;31:"
# LS_COLORS=$LS_COLORS:"*.bz2=01;31:"
# LS_COLORS=$LS_COLORS:"*.bz=01;31:"
# LS_COLORS=$LS_COLORS:"*.tbz=01;31:"
# LS_COLORS=$LS_COLORS:"*.tbz2=01;31:"
# LS_COLORS=$LS_COLORS:"*.tz=01;31:"
# LS_COLORS=$LS_COLORS:"*.deb=01;31:"
# LS_COLORS=$LS_COLORS:"*.rpm=01;31:"
# LS_COLORS=$LS_COLORS:"*.jar=01;31:"
# LS_COLORS=$LS_COLORS:"*.war=01;31:"
# LS_COLORS=$LS_COLORS:"*.ear=01;31:"
# LS_COLORS=$LS_COLORS:"*.sar=01;31:"
# LS_COLORS=$LS_COLORS:"*.rar=01;31:"
# LS_COLORS=$LS_COLORS:"*.alz=01;31:"
# LS_COLORS=$LS_COLORS:"*.ace=01;31:"
# LS_COLORS=$LS_COLORS:"*.zoo=01;31:"
# LS_COLORS=$LS_COLORS:"*.cpio=01;31:"
# LS_COLORS=$LS_COLORS:"*.7z=01;31:"
# LS_COLORS=$LS_COLORS:"*.rz=01;31:"
# LS_COLORS=$LS_COLORS:"*.cab=01;31:"
# LS_COLORS=$LS_COLORS:"*.wim=01;31:"
# LS_COLORS=$LS_COLORS:"*.swm=01;31:"
# LS_COLORS=$LS_COLORS:"*.dwm=01;31:"
# LS_COLORS=$LS_COLORS:"*.esd=01;31:"
# LS_COLORS=$LS_COLORS:"*.jpg=01;35:"
# LS_COLORS=$LS_COLORS:"*.jpeg=01;35:"
# LS_COLORS=$LS_COLORS:"*.mjpg=01;35:"
# LS_COLORS=$LS_COLORS:"*.mjpeg=01;35:"
# LS_COLORS=$LS_COLORS:"*.gif=01;35:"
# LS_COLORS=$LS_COLORS:"*.bmp=01;35:"
# LS_COLORS=$LS_COLORS:"*.pbm=01;35:"
# LS_COLORS=$LS_COLORS:"*.pgm=01;35:"
# LS_COLORS=$LS_COLORS:"*.ppm=01;35:"
# LS_COLORS=$LS_COLORS:"*.tga=01;35:"
# LS_COLORS=$LS_COLORS:"*.xbm=01;35:"
# LS_COLORS=$LS_COLORS:"*.xpm=01;35:"
# LS_COLORS=$LS_COLORS:"*.tif=01;35:"
# LS_COLORS=$LS_COLORS:"*.tiff=01;35:"
# LS_COLORS=$LS_COLORS:"*.png=01;35:"
# LS_COLORS=$LS_COLORS:"*.svg=01;35:"
# LS_COLORS=$LS_COLORS:"*.svgz=01;35:"
# LS_COLORS=$LS_COLORS:"*.mng=01;35:"
# LS_COLORS=$LS_COLORS:"*.pcx=01;35:"
# LS_COLORS=$LS_COLORS:"*.mov=01;35:"
# LS_COLORS=$LS_COLORS:"*.mpg=01;35:"
# LS_COLORS=$LS_COLORS:"*.mpeg=01;35:"
# LS_COLORS=$LS_COLORS:"*.m2v=01;35:"
# LS_COLORS=$LS_COLORS:"*.mkv=01;35:"
# LS_COLORS=$LS_COLORS:"*.webm=01;35:"
# LS_COLORS=$LS_COLORS:"*.ogm=01;35:"
# LS_COLORS=$LS_COLORS:"*.mp4=01;35:"
# LS_COLORS=$LS_COLORS:"*.m4v=01;35:"
# LS_COLORS=$LS_COLORS:"*.mp4v=01;35:"
# LS_COLORS=$LS_COLORS:"*.vob=01;35:"
# LS_COLORS=$LS_COLORS:"*.qt=01;35:"
# LS_COLORS=$LS_COLORS:"*.nuv=01;35:"
# LS_COLORS=$LS_COLORS:"*.wmv=01;35:"
# LS_COLORS=$LS_COLORS:"*.asf=01;35:"
# LS_COLORS=$LS_COLORS:"*.rm=01;35:"
# LS_COLORS=$LS_COLORS:"*.rmvb=01;35:"
# LS_COLORS=$LS_COLORS:"*.flc=01;35:"
# LS_COLORS=$LS_COLORS:"*.avi=01;35:"
# LS_COLORS=$LS_COLORS:"*.fli=01;35:"
# LS_COLORS=$LS_COLORS:"*.flv=01;35:"
# LS_COLORS=$LS_COLORS:"*.gl=01;35:"
# LS_COLORS=$LS_COLORS:"*.dl=01;35:"
# LS_COLORS=$LS_COLORS:"*.xcf=01;35:"
# LS_COLORS=$LS_COLORS:"*.xwd=01;35:"
# LS_COLORS=$LS_COLORS:"*.yuv=01;35:"
# LS_COLORS=$LS_COLORS:"*.cgm=01;35:"
# LS_COLORS=$LS_COLORS:"*.emf=01;35:"
# LS_COLORS=$LS_COLORS:"*.ogv=01;35:"
# LS_COLORS=$LS_COLORS:"*.ogx=01;35:"
# LS_COLORS=$LS_COLORS:"*.aac=00;36:"
# LS_COLORS=$LS_COLORS:"*.au=00;36:"
# LS_COLORS=$LS_COLORS:"*.flac=00;36:"
# LS_COLORS=$LS_COLORS:"*.m4a=00;36:"
# LS_COLORS=$LS_COLORS:"*.mid=00;36:"
# LS_COLORS=$LS_COLORS:"*.midi=00;36:"
# LS_COLORS=$LS_COLORS:"*.mka=00;36:"
# LS_COLORS=$LS_COLORS:"*.mp3=00;36:"
# LS_COLORS=$LS_COLORS:"*.mpc=00;36:"
# LS_COLORS=$LS_COLORS:"*.ogg=00;36:"
# LS_COLORS=$LS_COLORS:"*.ra=00;36:"
# LS_COLORS=$LS_COLORS:"*.wav=00;36:"
# LS_COLORS=$LS_COLORS:"*.oga=00;36:"
# LS_COLORS=$LS_COLORS:"*.opus=00;36:"
# LS_COLORS=$LS_COLORS:"*.spx=00;36:"
# LS_COLORS=$LS_COLORS:"*.xspf=00;36:"

export LS_COLORS

#xmodmap ~/.xmodmap


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
