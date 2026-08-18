#
# ~/.bashrc
#



# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias wine='LC_ALL=ja_JP.UTF-8 LANG=ja_JP.UTF-8 wine'

# Run Wine applications in the shared game prefix.
gamewine() {
    WINEPREFIX=/home/kodama/.local/share/wineprefixes/game \
        LC_ALL=ja_JP.UTF-8 LANG=ja_JP.UTF-8 command wine "$@"
}

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export PATH=$PATH:~/.local/bin
#export CLAUDE_CODE_OAUTH_TOKEN=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
source /usr/share/nvm/init-nvm.sh


eval "$(starship init bash)"


# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/kodama/.lmstudio/bin"
# End of LM Studio CLI section


# pnpm
export PNPM_HOME="/home/kodama/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
