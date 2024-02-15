#!/bin/zsh

ubin=$HOME/bin
mkdir -p $ubin

cp bash_functions.sh $ubin/

if [ -f ~/.zshrc ]; then
    echo "Backing up ~/.zshrc => ~/.zshrc.bkp"
    mv -v ~/.zshrc ~/.zshrc.bkp
fi

cp zshrc ~/.zshrc
