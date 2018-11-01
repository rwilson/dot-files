#!/bin/sh

ubin=$HOME/bin

mkdir -p $ubin
cp bash_* $ubin/

if [ -f ~/.profile ]; then
    echo "Backing up ~/.profile => ~/.profile.bkp"
    mv ~/.profile ~/.profile.bkp
fi

cp .profile ~/.profile
