# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=8000
SAVEHIST=8000
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
# if needed, it will truncate itself (eating the left side) to guarantee at
# least 45 characters of space after the prompt
PROMPT='%-45<...<%F{cyan}%~ %F{white}%# '
# make sure the sudoedit command uses vim (don't need to put vim's absolute path
# because sudo will check my PATH the program)
export SUDO_EDITOR=vim

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
