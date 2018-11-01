#!/bin/sh

ubin=$HOME/bin

if [ -f $ubin/bash_functions.sh ]; then
    source $ubin/bash_functions.sh
fi

if [ -f $ubin/bash_aliases.sh ]; then
    source $ubin/bash_aliases.sh
fi

if [ -f $ubin/git-completion.bash ]; then
    source $ubin/git-completion.bash
fi

# Always enable GREP colors
export GREP_OPTIONS='--color=auto'

export EDITOR=emacs
export GIT_EDITOR=emacs

# complete sudo and man pages
complete -cf sudo man

pathmunge $ubin
pathmunge "/Applications/Araxis Merge.app/Contents/Utilities" "after"
pathmunge "$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin"
pathmunge "$HOME/Library/Python/2.7/bin"
pathmunge "/Library/Frameworks/Python.framework/Versions/2.7/bin"
pathmunge "/Users/ryan/miniconda3/bin"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# White / reset: \[\033[00m\]
# Red: \[\033[0;31m\]
# Green: \[\033[0;32m\]
# Yellow: \[\033[0;33m\]
export PS1="\[\033[0;32m\]\w\[\033[0;33m\]\$(parse_git_branch)\[\033[00m\] $ "
