#!/bin/zsh

ubin=$HOME/bin

if [ -f $ubin/bash_functions.sh ]; then
    rm -fv $ubin/bash_functions.sh
fi

if [ -f ~/.zshrc ]; then
    rm -fv ~/.zshrc
fi

if [ -f ~/.zshrc.bkp ]; then 
    mv ~/.zshrc.bkp ~/.zshrc
fi
