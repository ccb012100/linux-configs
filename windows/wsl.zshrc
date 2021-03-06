export TERM="xterm-256color"

# setopt
setopt correct # spelling correction for commands
setopt correctall # spelling correction for all arguments
setopt histignoredups # don't store line in history if same as previous line
setopt noclobber # don't overwrite existing file

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

fpath=(~/.zsh $fpath)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
. ~/z/z.sh

# powerlevel9k theme
source  ~/powerlevel9k/powerlevel9k.zsh-theme

# `cd` and then `ls` in one command
cl(){
    cd "$@" && ls -A
}

case $(uname -a) in
   *Microsoft*) unsetopt BG_NICE ;;
esac

##############################
#         Aliases            #
##############################
alias ls='ls --color=auto'
alias ll='ls -Al'
alias la='ls -A'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort

alias g='git'
alias gc='git checkout'
alias gb='git branch'
alias gs='git status'
alias gl='git l'

alias nano='nano -mc'

alias sz='source ~/.zshrc'
alias nz='nano ~/.zshrc'

# CDABLEVARS
setopt cdablevars
c='/mnt/c'
gh='/mnt/c/GitHub'
code='/mnt/c/code'

LS_COLORS=$LS_COLORS:'ow=0;33;40' ; export LS_COLORS
