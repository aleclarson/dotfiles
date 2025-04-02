export HD2="/Volumes/Macintosh HD 2"

##################
# $PATH variable #
##################

# Node 23.7
export PATH="$HOME/.nvm/versions/node/v23.7.0/bin:$PATH"

# rust
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"

# python
export PATH="$HOME/.pyenv/versions/2.7.18/bin:$PATH"

# postgres
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# go
export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# flutter
export PATH="$HOME/dev/flutter/bin:$PATH"

# Custom binaries
export PATH="$HOME/dev/bin:$HOME/.local/bin:$PATH"

# homebrew
export PATH="/usr/local/bin:$PATH"

##############
# ZSH config #
##############

# zsh functions
fpath+=("$(brew --prefix)/share/zsh/site-functions")

# zsh plugins
plugins=(z fzf careful_rm)

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
export DISABLE_AUTO_UPDATE=true
export DISABLE_LS_COLORS=true
export DISABLE_MAGIC_FUNCTIONS=true
source $ZSH/oh-my-zsh.sh

#############################
# $PKG_CONFIG_PATH variable #
#############################

export PKG_CONFIG_PATH="/usr/local/opt/icu4c@76/lib/pkgconfig:$PKG_CONFIG_PATH"

#######################
# Interactive options #
#######################

if [[ $- =~ i ]]; then
  # Assume `cd` when executing a directory
  setopt autocd

  # Expand "{1-3}.png" to "1.png 2.png 3.png"
  setopt brace_ccl

  # https://github.com/sindresorhus/pure
  autoload -U promptinit
  promptinit
  prompt pure
fi

# See here: https://github.com/ohmyzsh/ohmyzsh/issues/449#issuecomment-1466968
unsetopt extendedglob

###############
# Git related #
###############

alias g="git"
alias ga="git add"
alias gap="git add -p"
alias gp="git push"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline -p"
alias gr="git rebase"
alias gs="git status"
alias gt="git tag"
alias gf="git fetch"
alias co="git checkout"
alias gcp="git cherry-pick --continue"
alias amend="git commit --amend --no-edit"
alias diffb='git show $(git merge-range)'

# Shows new changes in a specific file.
alias fdiff="git diff HEAD --"

# Reverts a specific file back to the HEAD.
alias revert="git co HEAD --"

# Push a WIP commit
alias wip="git-wip"

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

# Conventional commits
alias chore="git-cc chore"
alias feat="git-cc feat"
alias fix="git-cc fix"

# Breaking changes
alias feat!="git-cc feat!"
alias fix!="git-cc fix!"

git-cc() {
  if [ $# -ge 3 ] && [[ ! $3 =~ ^- ]]; then
    local type=$1
    local scope=$2
    local msg=$3
    if [[ $type == *"!" ]]; then
      type=${type%?}
      git commit -m "$type($scope)!: $msg" ${@:4}
    else
      git commit -m "$type($scope): $msg" ${@:4}
    fi
  elif [ $# -ge 2 ]; then
    git commit -m "$1: $2" ${@:3}
  else
    return 1
  fi
}

# Create a single commit git-patch and pbcopy it.
pbpatch() {
  if [ $# -eq 1 ]; then
    git format-patch --stdout -1 $1 | pbcopy
  elif [ $# -eq 0 ]; then
    pbpaste | git am
  fi
}

git-reword() {
  git commit --fixup reword:$1 &&
    GIT_EDITOR="cat" git rebase --autosquash -i $1^
}

# gcm [commit:-HEAD]
alias gcm="git-commit-message"
git-commit-message() {
  git log "$1^..$1" --pretty=%B
}

# tagd <tag> <commit> ...
git-tag-back() {
  GIT_COMMITTER_DATE="$(git show $2 --format=%aD | head -1)" \
    git tag $@
}

# tagf <remote> <tag>
git-tag-fetch() {
  git fetch $1 "refs/tags/$2:refs/tags/$2" --no-tags ${@:3}
}

# tagd <tag>
git-tag-delete() {
  git tag -d $1
  git push origin :$1
}

# tagda (local only)
git-tag-delete-all() {
  git tag -d $(git tag -l)
}

# branchd <branch-name>
git-branch-delete() {
  git branch -D $1
  git push origin --delete $1
}

git-wip() {
  git add -A
  git commit -m "wip"
  git push
}

#################
# Miscellaneous #
#################

export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# https://github.com/okbob/pspg
export PSQL_PAGER='pspg -X -b'

# Preferred CLI editor
export EDITOR="/usr/bin/vim"

# Go up two directories
alias ...="cd ../.."

# Recursive destroy
alias rm!="rm -rf --direct"

# Open in text editor
alias edit="code"

# Ripgrep with max line preview
alias rgc="rg --max-columns=100 --max-columns-preview"

# File scaffolding
alias ff="source ~/dev/bin/fileform"

alias inspect='NODE_OPTIONS="--inspect --enable-source-maps"'
alias inspect-brk='NODE_OPTIONS="--inspect-brk --enable-source-maps"'

random_str() {
  echo $(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-16} | head -n 1)
}

url_decode() {
  node -e "console.log(decodeURIComponent('$1'))"
}

url_encode() {
  node -e "console.log(encodeURIComponent('$1'))"
}

# HTTPie localhost
lh() {
  local url="https://localhost:${1#*:}/"
  shift
  echo "http --verify=false \"${@/#/:}\" \"$url\""
  http --verify=false "${@/#/:}" "$url"
}

# Lazy-loaded NodeJS version manager
nvm() {
  . ~/.nvm/nvm.sh && nvm $@
}

send_pr() {
  echo -n "Branch name: "
  read branch_name

  echo -n "Cherry pick: "
  read commit

  local target_branch="${1:-origin/master}"
  git checkout -b "$branch_name" "$target_branch" --no-track
  git cherry-pick "$commit"

  git show --color=always head | cat
  echo -n "Continue? [y/N] "
  read continue

  if [ "$continue" = "y" ]; then
    local target_branch_name="${target_branch##*/}"
    gh pr create --fill --base="$target_branch_name"
  else
    echo "Aborting..."
    git checkout -
    git branch -D "$branch_name"
  fi
}

#compdef pnpm
###-begin-pnpm-completion-###
if type compdef &>/dev/null; then
  _pnpm_completion () {
    local reply
    local si=$IFS

    IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" SHELL=zsh pnpm completion-server -- "${words[@]}"))
    IFS=$si

    if [ "$reply" = "__tabtab_complete_files__" ]; then
      _files
    else
      _describe 'values' reply
    fi
  }
  # When called by the Zsh completion system, this will end with
  # "loadautofunc" when initially autoloaded and "shfunc" later on, otherwise,
  # the script was "eval"-ed so use "compdef" to register it with the
  # completion system
  if [[ $zsh_eval_context == *func ]]; then
    _pnpm_completion "$@"
  else
    compdef _pnpm_completion pnpm
  fi
fi
###-end-pnpm-completion-###

