# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=4000
SAVEHIST=4000
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
# be able to go in the other direction if you overshoot your search result
bindkey ^T history-incremental-search-forward

# prompt with present dir and privilege character (%/#)
PROMPT='%F{cyan}%~ %F{white}%# '
# make sure the sudoedit command uses vim
export SUDO_EDITOR=/usr/bin/vim

# lowercase letters can match uppercase letters with tab completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# don't save a command if it is equal to the command before it
setopt HIST_IGNORE_DUPS
# don't save a command if it has a space in front of it
setopt HIST_IGNORE_SPACE
# when searching history, show unique results
setopt HIST_FIND_NO_DUPS

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

if [ -f ~/.fortunes/fortunes ] && [ -f ~/.fortunes/fortunes.dat ]; then
    fortune ~/.fortunes/
fi
