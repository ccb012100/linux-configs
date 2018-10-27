# NOTE: set mintty theme to "rosipov"

# Path to your oh-my-zsh installation.
export ZSH="/home/chris/.oh-my-zsh"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=( git zsh-auto-suggestions )

source $ZSH/oh-my-zsh.sh

ZSH_THEME=agnoster

export SSH_KEY_PATH="~/.ssh/rsa_id" # ssh

fpath=(~/.zsh $fpath)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # fzf

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
    cd "$@" && ls -A
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
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort

#-----------------------------
# CDABLEVARS
#-----------------------------
setopt cdablevars
c='/c'
gh='/c/GitHub/'

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
      vcs_info
      print -Pn "\e]0;[%n@%M][%~]%#\a"
    }
    preexec () { print -Pn "\e]0;[%n@%M][%~]%# ($1)\a" }
    ;;
  screen|screen-256color)
    precmd () {
      vcs_info
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a"
    }
    preexec () {
      print -Pn "\e]83;title \"$1\"\a"
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a"
    }
    ;;
esac

#-----------------------------
# Dircolors
#-----------------------------
LS_COLORS=$LS_COLORS:'rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:'; export LS_COLORS
#LS_COLORS=$LS_COLORS:'di=0;35:ow=0;33;40' ; export LS_COLORS

autoload -U colors zsh/terminfo
colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "(%{${fg[yellow]}%}%b%{${fg[red]}%}%m%u%c%{$reset_color%})%{$reset_color%}"

setprompt() {
  setopt prompt_subst

  if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
    p_host='%F{yellow}%M%f'
  else
    p_host='%F{green}%M%f'
  fi

  PS1=${(j::Q)${(Z:Cn:):-$'# user@hostname + ♫ + PWD + ♠ + git + %
    %(!.%F{red}%n%f.%F{yellow}%n%f)
    @
    ${p_host}
    " "
    %F{blue}%~%f
    %F{cyan} %f
    " "
    %(!.%F{red}%#%f.%F{cyan}%#%f)
    " "
  '}}

  PS2=$'%_>'
  RPROMPT=$'${vcs_info_msg_0_}[ %F{magenta}%t%f %F{yellow}%W%f ]' # %t = 12 hour time AM/PM; %W = MM/DD/YYYY
}
setprompt
