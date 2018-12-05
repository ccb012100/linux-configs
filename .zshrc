# NOTE: set mintty theme to "rosipov"

export SSH_KEY_PATH="~/.ssh/rsa_id" # ssh
source ~/git-completion.bash
fpath=(~/.zsh $fpath)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # fzf

bindkey '\e[H' beginning-of-line #HOME key
bindkey '\e[F' end-of-line # END key
bindkey "\e[3~" delete-char # DELETE key
bindkey "^[[1;5C" forward-word # CTRL right-arrow
bindkey "^[[1;5D" backward-word # CTRL left-arrow

#-----------------------------
# agkozak prompt
#-----------------------------
source ~/agkozak-zsh-prompt/agkozak-zsh-prompt.plugin.zsh

# left prompt
AGKOZAK_CUSTOM_PROMPT='%F{blue}[%h]%f%F{yellow} %D{%H:%M:%S}%f%F{cyan} %D{%a %b-%d}%f' #%t = 12 hour time AM/PM
AGKOZAK_CUSTOM_PROMPT+=' %(!.%S%B.%B%F{green})%n%1v%(!.%b%s.%f%b) '
AGKOZAK_CUSTOM_PROMPT+=$'%B%F{blue}%2v%f%b%(3V.%F{yellow}%3v%f.)'
AGKOZAK_CUSTOM_PROMPT+=' %(?..%B%F{red}(%?%)%f%b)'
AGKOZAK_CUSTOM_PROMPT+='
'
AGKOZAK_CUSTOM_PROMPT+='$(_agkozak_vi_mode_indicator) '

# right prompt
#AGKOZAK_CUSTOM_RPROMPT=''

#-----------------------------
# setopt
#-----------------------------
setopt correct # spelling correction for commands
setopt correctall # spelling correction for all arguments
setopt histignoredups # don't store line in history if same as previous line
#setopt noclobber # don't overwrite existing file

. /c/GitHub/z/z.sh

#------------------------------
# History
#------------------------------
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

#-----------------------------
# `cd` and then `ls` in one command
#-----------------------------
cl(){
    cd "$@" && ls --color=auto -A
}

#-----------------------------
# WSL fix for zsh
#-----------------------------
case $(uname -a) in
    *Microsoft*) unsetopt BG_NICE ;;
esac

#-----------------------------
# Alias
#-----------------------------
alias sz='source ~/.zshrc'
alias nz='nano ~/.zshrc'
alias ls='ls --color=auto'
alias ll='ls -Al'
alias la='ls -A'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias g='git'
alias gc='git checkout'
alias gb='git branch'
alias gs='git status'
alias gl='git l'
alias less='less -r'   # raw control characters
alias whence='type -a' # where, of a sort

#-----------------------------
# CDABLEVARS
#-----------------------------
setopt cdablevars
c='/c'
gh='/c/GitHub'
code='/c/code'
temp='/c/temp'
v3='/c/code/vpay360'
vpayrest='/c/code/vpay-rest-api'

#------------------------------
# coloured man pages
#------------------------------
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

#------------------------------
# Window title
#------------------------------
case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () {
      print -Pn "\e]0;%n@%M:%~ %#\a"
    }
    preexec () { print -Pn "\e]0;%n@%M:%~ %# ($1)\a" }
    ;;
  screen|screen-256color)
    precmd () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - (%L) %n@%M:%# %~\a"
    }
    preexec () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - (%L) %n@%M:%# %~ ($1)\a"
    }
    ;;
esac

# 
# function cd_func
# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
cd_func ()
{
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 ==  "--" ]]; then
    dirs -v
    return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    #
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi

  #
  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
    x2=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
      cnt=cnt-1
    fi
  done

  return 0
}

alias cd=cd_func

# function settitle
settitle () 
{ 
  echo -ne "\e]2;$@\a\e]1;$@\a"; 
}
