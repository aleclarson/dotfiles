# https://github.com/sindresorhus/pure
autoload -U promptinit; promptinit
prompt pure

# Preferred CLI editor
export EDITOR="/usr/bin/vim"

# NodeJS version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Command registry
export PATH="$PATH:$HOME/dev/bin"

# Global node_modules
export NODE_PATH="$(pnpm root -g)"

# Go up two directories
alias ...="cd ../.."

# Open in text editor
alias edit="open -a /Applications/Visual\ Studio\ Code.app"

#######################
# Interactive options #
#######################

if [[ $- =~ i ]]; then
  # Assume `cd` when executing a directory
  setopt autocd

  # Expand "{1-3}.png" to "1.png 2.png 3.png"
  setopt brace_ccl

  # Fuzzy finder
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  # rupa/z: jump to recent directories with ease
  source ~/dev/tools/z.sh
fi

###############
# Git related #
###############

alias g="git"
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gr="git rebase"
alias gt="git tag"
alias co="git checkout"
alias amend="git commit --amend --no-edit"

# Shows new changes in a specific file.
alias diff="git diff HEAD --"

# Reverts a specific file back to the HEAD.
alias revert="git co HEAD --"

# Push the current branch to origin.
alias push="git push origin HEAD"

# Compact commit logs
alias log="git log --oneline"

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

alias renovate="wget https://gist.githubusercontent.com/aleclarson/99bf0948466ad764a2e90ae462c9d3b2/raw/renovate.json"

alias linkify='xargs -I {} ln -f -s $PWD/{} $(pnpm root -g)'

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
