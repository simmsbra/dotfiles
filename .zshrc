eval $(dircolors) # sets LS_COLORS for zsh completion colors below
# The following lines were added by compinstall
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle :compinstall filename '/home/brandon/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


HISTFILE=~/.histfile
HISTSIZE=16000
SAVEHIST=16000

# use vim mode
bindkey -v
# make Ctrl-R work like default bash -- search though history for pattern
bindkey ^R history-incremental-search-backward
# be able to go in the other direction if you overshoot your search result
bindkey ^T history-incremental-search-forward
# swap some keys to match my vim config
bindkey -M vicmd h vi-replace-chars
bindkey -M vicmd H vi-replace
bindkey -M vicmd r vi-backward-char
bindkey -M vicmd d vi-substitute
bindkey -M vicmd D vi-change-whole-line
bindkey -M vicmd s vi-delete
bindkey -M vicmd S vi-kill-eol
bindkey -M vicmd -r b
bindkey -M vicmd q vi-backward-word

# prompt with present dir and privilege character (%/#)
# if needed, it will truncate itself (eating the left side) to guarantee at
# least 45 characters of space after the prompt
PROMPT='%-45<...<%F{cyan}%~ %F{white}%# '

# lowercase letters can match uppercase letters with tab completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# don't save a command if it is equal to the command before it
setopt HIST_IGNORE_DUPS
# don't save a command if it has a space in front of it
setopt HIST_IGNORE_SPACE
# when searching history, show unique results
setopt HIST_FIND_NO_DUPS
# share history between shells that are open at the same time. amazing!
setopt SHARE_HISTORY

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

if [ -f ~/.fortunes/fortunes ] && [ -f ~/.fortunes/fortunes.dat ]; then
    fortune ~/.fortunes/
fi

export PATH="$PATH:/opt/nvim-linux64/bin"

# make sure that the sudoedit command uses neovim, if it's available
if command -v nvim > /dev/null ; then
    export SUDO_EDITOR=$(which nvim)
fi
