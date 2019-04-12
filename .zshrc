# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/brandon/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# make Ctrl-R work like default bash
# search though history for pattern
bindkey ^R history-incremental-search-backward

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# prompt with present dir and privilege character (%/#)
PROMPT='%F{cyan}%~ %F{white}%# '
# lowercase letters can match uppercase letters with tab completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# don't save a command if it is equal to the command before it
setopt HIST_IGNORE_DUPS
