eval "$(/opt/homebrew/bin/brew shellenv)"

ubin=$HOME/bin

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'

# listing shortcuts
alias ls='ls -GF'
alias ll='ls -l'
alias la='ls -lA'

# language aliases
alias py3='python3'

# Load helper functions
if [ -f $ubin/bash_functions.sh ]; then
    source $ubin/bash_functions.sh
fi

# Add the dot-files dir to path
pathmunge $ubin

# Always enable GREP colors
export GREP_OPTIONS='--color=auto'

# Set default editor
export EDITOR=emacs
export GIT_EDITOR=emacs

# Setup git auto complete
autoload -Uz compinit && compinit

# Customize prompt with VCS info
# Inspired by https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
# Default prompt: PS1="%n@%m %1~ %#"

setopt prompt_subst   # enable expansion in prompt string, see https://zsh.sourceforge.io/Doc/Release/Expansion.html
autoload -Uz vcs_info # load vcs_info to display info about version control repos

# Can also use RPROMPT to set on the right side
# %n = account username
# %m = host name
# %1 = cwd
# %# = prompt will show # if shell is running as root, otherwise %
# Color: $F{color}content%f
precmd_vcs_info() {
    # Run the system so everything is setup correctly
    vcs_info

    # Nothing from vcs_info, so not in a VCS dir
    if [[ -z ${vcs_info_msg_0_} ]]; then
	PROMPT="%n@%m %5~ %# "
    else
	PROMPT="%n@%m %3~ %B${vcs_info_msg_0_}%b %# "
    fi
}
precmd_functions+=( precmd_vcs_info )

### Display the existence of files not yet known to VCS
# git: Show marker (T) if there are untracked files in repository
# Enable by adding staged (%c) to 'formats'
function +vi-git-set-message-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
           git status --porcelain | grep -q '^?? ' 2> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='T'
    fi
}

### Compare local changes to remote changes
# Show +N/-N when your local branch is ahead-of or behind remote HEAD.
# Enable by adding misc (%m) to 'formats'
function +vi-git-set-message-st() {
    local ahead behind
    local -a gitstatus

    # Exit early in case the worktree is on a detached HEAD
    # Note: this is incorrect if run _after_ +vi-git-set-message-remotebranch
    git rev-parse ${hook_com[branch]}@{upstream} >/dev/null 2>&1 || return 0

    local -a ahead_and_behind=(
        $(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null)
    )

    ahead=${ahead_and_behind[1]}
    behind=${ahead_and_behind[2]}

    (( $ahead )) && gitstatus+=( "+${ahead}" )
    (( $behind )) && gitstatus+=( "-${behind}" )

    hook_com[misc]+=${(j:/:)gitstatus}
}

# git: Show remote branch name for remote-tracking branches
# Enable by adding branch (%b) to 'formats'
function +vi-git-set-message-remotebranch() {
    local remote

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
		   --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    
    # The first test will show a tracking branch whenever there is one. The
    # second test, however, will only show the remote branch's name if it
    # differs from the local one.
    #if [[ -n ${remote} ]] ; then
    if [[ -n ${remote} && ${remote#*/} != ${hook_com[branch]} ]] ; then
	hook_com[branch]="${hook_com[branch]}:${remote}"
    fi
}


# Derive hook names dynamically, any function named +vi-git-set-message-*
zstyle -e ':vcs_info:git+set-message:*' hooks 'reply=( ${${(k)functions[(I)[+]vi-git-set-message*]}#+vi-} )'

# %s = vcs program, e.g. "git"
# %b = branch
# %i = hash, %12.12i = hash truncated to 12 chars
# %c = are there untracked files?
# %m = misc
zstyle ':vcs_info:git:*' formats '(%b)-%c %m'

# Enable / disable debug output
zstyle ':vcs_info:git+set-message:*' debug false
