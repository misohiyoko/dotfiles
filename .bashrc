#
# ~/.bashrc
#



# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export PATH=$PATH:~/.local/bin

source /usr/share/nvm/init-nvm.sh


eval "$(starship init bash)"


# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/kodama/.lmstudio/bin"
# End of LM Studio CLI section

