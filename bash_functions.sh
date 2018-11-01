#!/bin/sh

function path() {
    old=$IFS
    IFS=:
    printf "%s\n" $PATH
    IFS=$old
}

function pathmunge() {
    if ! echo $PATH | /usr/bin/egrep -q "(^|:)$1($|:)"; then
	if [ "$2" = "after" ]; then
	    PATH="$PATH:$1"
	else
	    PATH="$1:$PATH"
	fi
    fi
}

function fng() {
    if [ $# -ne 2 ]; then
	echo "Combination of find and grep"
	echo "Usage: fng <FILE_PATTERN> <GREP_STRING>"
	return 1
    fi

    find . -type f -iname $1 -exec grep -l $2 {} \;
}

function frm() {
    if [ $# -eq 0 ]; then
        echo "Like find --delete, but interactive"
	echo "Usage: frm file [file1 file2 ... fileN]"
	return 1
    fi

    while (( "$#" )); do
	for FILE in $(find . -type f -iname "$1"); do
	    rm -i $FILE
	done
	shift
    done
}

function fopen() {
    if [ $# -ne 1 ]; then
	echo "Usage: fopen filename"
	return 1
    fi

    find . -type f -iname "$1" -exec open {} \;
}

function transfer-key() {
    if [  $# -lt 1 ]; then
	echo "Usage: transfer-key <hostname> [username]"
	return 1
    fi

    server="$1"
    user="$2" || `whoami`
    ssh $user@$server mkdir -p .ssh
    cat ~/.ssh/id_rsa.pub | ssh $user@$server 'cat >> .ssh/authorized_keys'
}
