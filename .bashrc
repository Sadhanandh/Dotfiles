#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running inter>'
[ -z "$PS1" ] && return

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
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

goog() {
	    search=""
		echo "Done"
		for term in $*; do
		search="$search%20$term"
	    done
	    xdg-open "http://www.google.com/search?q=$search"
		}

googifl() {
	    search=""
		echo "Done"
		for term in $*; do
		search="$search%20$term"
	    done
		
		xdg-open "http://www.google.com/search?ie=UTF-8&oe=UTF-8&sourceid=navclient&gfns=1&q=$search"
		}

dictref() {
	    search=""
		echo "Done"
		for term in $*; do
		search="$search%20$term"
	    done

	xdg-open "http://dictionary.reference.com/browse/$search?fromAsk=true&o=100074"
		}


wikipedia() {
	    search=""
		echo "Done"
		for term in $*; do
		search="$search%20$term"
	    done

	xdg-open "http://en.wikipedia.org/wiki/Special:Search?search=$search"
		}
function n ()
{
	echo $1
	vim "~/Dropbox/epistle/$1.txt"
}

function ni ()
{
	cd ~/Dropbox/epistle
	grep "$1" * 
}

function ns ()
{
	echo "-------------------------"
	ls -c1 ~/Dropbox/epistle | grep -i "$1" |more
	echo "-------------------------"
}


function myfind ()
{
#myfind "variable"
#myfind "variable" "*.c"
#myfind "variable" "*.c" "/home"
v1="*"; v2="*"; v3="."; 

if (( $# >= 3 )); 
then v3=$3;  
fi; 

if (( $# >=2 )); 
then v2=$2; 
fi; 

if (( $# >=1 )); 
then v1=$1; 
fi; 


	echo "-------------------------"
	find "$v3" -name "$v2" -exec grep -E -H "$v1" {} \;
	#find . -name "*" -exec grep -E -H "$1" {} \;
	echo "-------------------------"
}


function myfind1 ()
{
	echo "-------------------------"
	find . -name "$1" -exec grep -E -H "$2" {} \;
	echo "-------------------------"
}



oldps=$PS1
newps='user@host $'
alias change='PS1=$newps'
alias back='PS1=$oldps'
alias c='clear'
alias p='python'
alias sagi='sudo apt-get install'
alias sagu='sudo apt-get update'
alias sacs='sudo apt-cache search'
alias g='gvim'
alias cx='chmod +x'
alias lg='sudo logkeys --start --output=/output.log'
alias lk='sudo logkeys -k'
alias pyradio='~/usr/pyradio/pyradio'
alias gg='goog'
alias gh='googifl'
alias hh='dictref'
alias ff='wikipedia'
alias crl='curl www.google.com'
export PYTHONSTARTUP="/home/xadmin/.pyrc"
alias tcd='/usr/lib/jvm/java-6-sun/bin/javaws ~/ContestAppletProd.jnlp & midori & cd ~/space/coder/topcoders/srm/ '
test -r /home/xadmin/usr/algs4/bin/config.sh && source /home/xadmin/usr/algs4/bin/config.sh
[[ -s ~/usr/autojump/etc/profile.d/autojump.bash ]] && source ~/usr/autojump/etc/profile.d/autojump.bash
alias topcoder="/usr/lib/jvm/java-6-sun/bin/javaws ~/usr/ContestAppletProd.jnlp"
alias netff="firefox -P "net" -no-remote &"
alias cloud9="~/usr/cloud9/cloud9/bin/cloud9.sh & sleep 100 ;exit;"
alias cloud0="~/usr/cloud9/projectswitch.sh"
export GRIP="$HOME/usr/Grip/"
export DISLIN="$HOME/usr/dislin"
export DJANGO="/home/xadmin/usr/Django-1.4.3"
export FLASK="/home/xadmin/usr/Flask-0.9/"
export PIPE2PY="/home/xadmin/usr/pipe2py/"
export PYTHON_WEBKIT="/home/xadmin/usr/python-webkit/"
PATH=$PATH:$DISLIN/bin
PATH=$PATH:/home/xadmin/usr/lpath
export PYTHONPATH="$DISLIN/python:$DJANGO/:$PYTHON_WEBKIT:$FLASK:$GRIP:$PIPE2PY"
PATH=$PATH:$DJANGO/django/bin
PATH=$PATH:$GRIP
export LD_LIBRARY_PATH=$DISLIN:$LD_LIBRARY_PATH
alias stogit="git config credential.helper cache"
export PYCHARM_JDK="/usr/lib/jvm/java-6-sun/"
PS1="Sadhanandh@Ubuntu:\w\$ "

alias pres="webfsd -F -p 8888 -r ${HOME}/Dropbox/Public/Presentation -f Presenter.html"

alias pi="ping 192.168.1.103"
alias apai="sudo service apache2 start"
alias apas="sudo service apache2 stop"
alias jws="/usr/lib/jvm/java-6-sun/bin/javaws -viewer"
alias ']'='xdg-open'


alias mir='wget --mirror -p --convert-links -P ~/Books/Wget '
alias all='wget -r -A'
alias pyinstaller.py="/home/xadmin/usr/pyinstaller-2.0/pyinstaller.py"
alias xc="xclip -sel clip"
alias cha="ncat -l 12345 --keep-open --chat"
alias con="ncat 127.0.0.1 12345"
alias sshme="sudo service ssh start"
alias ssh1="ssh ipg_2009067@192.168.1.102"
alias ly="lynx -pauth=uname:pass"
alias li="links2 -g -http-proxy @192.168.1.103:3128"
alias pin="ping 192.168.1.103"
alias blog=". ${HOME}/virtualenvs/pelican/bin/activate;cd ${HOME}/Git/bloghelper"
alias flask="cd ~/virtualenvs/flask/;. bin/activate;cd ${tempv};cd -"
alias django="tempv=$(pwd);cd ~/virtualenvs/django/;. bin/activate;cd `${tempv}`;echo ${tempv}"
alias vb="vim +BundleInstall +qall"
alias adb="${HOME}/usr/adt-bundle-linux-x86/sdk/platform-tools/adb"
# w3m
alias removeme='sudo update-rc.d -f '
alias conk="nohup conky &"
alias moni="xrandr --output LVDS --pos 0x0 --mode 1366x768"
alias moni1="xrandr --output LVDS --pos 0x0 --mode 1366x768 --output CRT1 --pos 1366x0 --mode 1280x720"
alias moni2="xrandr --output LVDS --mode 1366x768 --panning 1366x768"
alias moni3="xrandr --fb 1366x768 --output LVDS --mode 1366x768 --panning 1366x768"
alias dis="export DISPLAY=0:0"
alias dis1="export DISPLAY=:1.0"
alias monigag="xrandr --output LVDS --mode 1366x768 --pos 0x0 --output CRT1 --mode 1280x768 --pos 1366x0"
alias vimlog="vim --startuptime /dev/stdout +qall | sort -s -n -k 2"
alias v="vim -u ~/.vimrc-alt"
#alias xphr="Xephyr -ac -br -noreset -screen 1366x750 :1 &" 
alias xmona="DISPLAY=:1 xmonad &"
alias xphr="Xephyr -ac -br -noreset -host-cursor -screen 1366x764 -fullscreen -dpi 100 :1 &sleep 1 ;DISPLAY=:1;feh --bg-fill /home/xadmin/Pictures/waterfall.jpg;xmonad &" 
alias xph="xinit ~/xephyr.xinitrc -- /usr/bin/Xephyr :1 -ac -br -noreset -host-cursor -screen 1366x764 -fullscreen -dpi 100 " 
alias startme="startx ~/xephyr.xinitrc -- :1"
alias syncx="/home/xadmin/syncx :0 :1"

#alias trayer1="trayer --edge top --align right --SetDockType true --SetPartialStrut true  --widthtype pixel --heighttype pixel --expand true --width 5 --transparent true --alpha 0 --tint 0x000000 --height 12 --margin 0&"
alias trayer1="trayer --edge top --align right --SetDockType true --SetPartialStrut true  --expand true --width 5 --transparent true --alpha 0 --tint 0x000000 --height 12 --margin 0&"
alias trayer2=" trayer --edge top --align right --widthtype pixel --heighttype pixel --expand true --align right --SetDockType true --SetPartialStrut true --tint 0x000000 --transparent true --alpha 0 --margin 0 --height 8 --width 160"

alias pyf="~/.xmonad/easyxmotion.py --colour='#0fff00' --font='-adobe-helvetica-bold-r-normal-*-24-*-*-*-*-*-iso8859-1'"
alias xcom="xcompmgr -fF -I-.002 -O-.003 -D1 &"
alias xmo="xmonad --replace &"
alias xfw="xfwm4 --replace &"
alias wcoll="cd ~/usr/recoll-webui/; ./web "
export BC_ENV_ARGS=~/.bc
function viopener()
{
    echo $@;
    gnome-terminal -e "vi $@";
}
alias screenlets="python -u /usr/share/screenlets/screenlets-pack-basic/Sysnitor/SysmonitorScreenlet.py > /dev/null/"
alias xpanel="xfce4-panel -r"
alias myosd0="osd_clock -f '-*-lucidatypewriter-medium-*-*-*-17-*-*-*-*-*-*-*' -s 0 -b  -r &"

alias myosd="osd_clock -f '-*-lucidatypewriter-medium-*-*-*-17-*-*-*-*-*-*-*' -s 0 -b  -r  -F '%A  --  %d %B %Y  --  %I:%M  %p' &"
alias myosd1="osd_clock -f '-*-lucidatypewriter-medium-*-*-*-17-*-*-*-*-*-*-*' -s 0 -b  -r  -F '%A  --  %d %B %Y  --  %I:%M:%S  %p' &"
alias myosd2="osd_clock -c blue -s 0 -t &"
#export TESSDATA_PREFIX=/home/xadmin/Desktop/finaly/pytesser/
alias minit="xinit -- :2"
alias ipn="ipython notebook"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

