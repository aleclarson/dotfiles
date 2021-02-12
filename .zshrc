# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(fzf k zsh-z)

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
export DISABLE_LS_COLORS="true"
source $ZSH/oh-my-zsh.sh

# https://github.com/sindresorhus/pure
autoload -U promptinit; promptinit
prompt pure

# Preferred CLI editor
export EDITOR="/usr/bin/vim"
export REACT_EDITOR="code"

# Go up two directories
alias ...="cd ../.."

# Open in text editor
alias edit="open -a /Applications/Visual\ Studio\ Code.app"

# File scaffolding
alias ff="source ~/dev/bin/fileform"

##################
# $PATH variable #
##################

# ruby gems
export PATH="/usr/local/Cellar/ruby/2.7.0/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"

# rvm
export PATH="$PATH:$HOME/.rvm/bin"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# python
# export PATH="$HOME/Library/Python/2.7/bin"

# Custom binaries
export PATH="$HOME/dev/bin:$PATH"

###########
# Node JS #
###########

NODE_VERSION=`node -v | tr -d v`

# Global node_modules
export NODE_PATH="/usr/local/Cellar/node/$NODE_VERSION/pnpm-global/4/node_modules"

#######################
# Interactive options #
#######################

if [[ $- =~ i ]]; then
  # Assume `cd` when executing a directory
  setopt autocd

  # Expand "{1-3}.png" to "1.png 2.png 3.png"
  setopt brace_ccl

  # See here: https://github.com/ohmyzsh/ohmyzsh/issues/449#issuecomment-1466968
  unsetopt extendedglob
fi

###############
# Git related #
###############

alias g="git"
alias ga="git add"
alias gp="git push"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gr="git rebase"
alias gt="git tag"
alias gf="git fetch"
alias co="git checkout"
alias gcp="git cherry-pick --continue"
alias amend="git commit --amend --no-edit"

# Shows new changes in a specific file.
alias fdiff="git diff HEAD --"

# Reverts a specific file back to the HEAD.
alias revert="git co HEAD --"

# Delete a branch locally and remotely
alias branchd="git-branch-delete"

# Tag an old commit
alias btag="git-tag-back"

# Tag utils
alias tagf="git-tag-fetch"
alias tagd="git-tag-delete"
alias tagda="git-tag-delete-all"

# Remove paths matching .gitignore globs
alias ignore="git rm -r --cached . && git add ."

# Create a single commit git-patch and pbcopy it.
pbpatch() {
  if [ $# -eq 1 ]; then
    git format-patch --stdout -1 $1 | pbcopy
  elif [ $# -eq 0 ]; then
    pbpaste | git am
  fi
}

# gcm [commit:-HEAD]
alias gcm="git-commit-message"
git-commit-message () {
  git log "$1^..$1" --pretty=%B
}

# tagd <tag> <commit> ...
git-tag-back () {
  GIT_COMMITTER_DATE="$(git show $2 --format=%aD | head -1)" \
  git tag $@
}

# tagf <remote> <tag>
git-tag-fetch() {
  git fetch $1 "refs/tags/$2:refs/tags/$2" --no-tags ${@:3}
}

# tagd <tag>
git-tag-delete () {
  git tag -d $1
  git push origin :$1
}

# tagda (local only)
git-tag-delete-all () {
  git tag -d $(git tag -l)
}

# branchd <branch-name>
git-branch-delete () {
  git branch -D $1
  git push origin --delete $1
}

#################
# Miscellaneous #
#################

alias inspect='NODE_OPTIONS="--inspect"'
alias inspect-brk='NODE_OPTIONS="--inspect-brk"'

JEST_NO_CACHE="./node_modules/.bin/jest -i --no-cache --watch"
alias jest-dbg="$JEST_NO_CACHE"
alias jest-brk="node --inspect-brk $JEST_NO_CACHE"

# rm == move to trash
alias _rm="$(which rm)"
alias rm="del"
del() {
  while [ -n "$1" ]; do
    if [ ! -e "$1" -a ! -h "$1" ]; then
      echo "'$1' not found; exiting"
      return
    fi

    local file=`basename -- "$1"`

    # Chop trailing '/' if there
    file=${file%/}

    local destination=''

    if [ -e "$HOME/.Trash/$file" ]; then
      # Extract file and extension
      local ext=`expr "$file" : ".*\(\.[^\.]*\)$"`
      local base=${file%$ext}

      # Add a space between base and timestamp
      test -n "$base" && base="$base "

      destination="/$base`date +%H-%M-%S`_$RANDOM$ext"
    fi

    echo "Moving '$1' to '$HOME/.Trash$destination'"
    \mv -i -- "$1" "$HOME/.Trash$destination" || return
    shift
 done
}
