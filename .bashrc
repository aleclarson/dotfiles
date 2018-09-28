export SHELL="/usr/local/bin/bash"
export EDITOR="/usr/bin/vim"

alias ..="cd ../"
alias ...="cd ../../"

# Log levels
export DEBUG=""
export VERBOSE=""

# Fuzzy finder for terminal
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# NodeJS version manager
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"

# Global node_modules
export NODE_PATH="$HOME/lib/node_modules:$HOME/pnpm-global/1/node_modules"

# Command registry
export PATH="$PATH:$HOME/bin"

# Manual pages
export MANPATH="$HOME/share/man:$MANPATH"

# Open manual pages in vim
alias man="viman"

# Open in text editor
alias edit="open -a /Applications/Visual\ Studio\ Code.app"

# rm == move to trash
alias _rm="$(which rm)"
alias rm="del"

# Load RVM into a shell session *as a function*
# [[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm

# Python 3.5
# export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.5/bin"

# Python 2.7.14
# export PATH="$PATH:/usr/local/opt/python@2/bin"

# Google Cloud SDK
# export PATH="$PATH:~/google-cloud-sdk/bin"

# Enable auto-completion for gcloud
# [[ -s ~/google-cloud-sdk/completion.bash.inc ]] && source ~/google-cloud-sdk/completion.bash.inc



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



#################
# Prompt layout #
#################

_pwd_three() {
  # the path to the working directory (up to three dirs long)
  # http://www.reddit.com/r/programming/comments/697cu/bash_users_what_do_you_have_for_your_ps1/c0382ne
  echo ${PWD} | sed "s&${HOME}&~&" | sed "s&.*./\([^/]*/[^/]*/[^/]*\)$&\1&"
}

_parse_git_branch() {
  # http://martinfitzpatrick.name/article/add-git-branch-name-to-terminal-prompt-mac
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

_color() {
  echo '\[\e[38;5;'$2'm\]'$1'\[\e[39m\]'
}

# change command prompt
PS1=$(_color '$(_pwd_three)$(_parse_git_branch)' 227)
PS1=$PS1' '$(_color "\$" 229)' '
export PS1



#############
# Functions #
#############

cdl() {
  cd ~/lib/$@
}

rip() {
  rg --pretty "$@" | less -r
}

viman() {
  vim -c "Man $1 $2" -c 'silent only'
}

node-inspect() {
  local TAB_ID=`chrome-cli open 'chrome://inspect/#devices' -n | head -n 1 | awk '{ print $2 }'`
  sleep 0.5
  chrome-cli execute "document.getElementById('node-frontend').click()" -t $TAB_ID && chrome-cli close -t $TAB_ID
  node --inspect-brk $@
}

headers() {
  curl -s -D - -o /dev/null $@
}

localIp() {
  ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
}

lastModified() {
  stat -f "%Sm" -t "%m/%d/20%y %H:%M" "$1"
}

hardenSymlinks() {
  find $PWD -type l -exec bash -c 'ln -f "$(readlink "$0")" "$0"' {} \;
}

watchFile() {
  while `inotifywait -e close_write $1 &> /dev/null`; do clear && echo "$(cat $1)"; done
}

touchAll() {
  ls -1 | xargs -L1 touch
}

deleteThisBranch() {
  CURRENT="$(git rev-parse --abbrev-ref HEAD)"
  NEXT=${1:-master}
  if [ "$NEXT" == "$CURRENT" ]; then
    echo "Must provide a branch different than the current one"
  else
    git co $NEXT && git branch -D $CURRENT
  fi
}

# For merging one file with another.
mergeInto() {
  touch EMPTY_FILE
  git merge-file $1 EMPTY_FILE $2
  rm EMPTY_FILE
}

mergeTheirs() {
  git merge "$1" -X theirs --no-commit
  git reset && git commit # Keep the changes, abort the merge commit.
}

# backtag <tag> <commit> ...
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

# git-branch-name
git-branch-name () {
  echo $( git rev-parse --abbrev-ref HEAD )
}

port-info () {
  echo -e $( sudo lsof -i :$1 )
}

# port-id <port-number>
port-id () {
  local results=$( lsof -i tcp:$1 | awk 'NR!=1 {print $2}' )
  [ -n "$results" ] && echo $results
}

# is-vacant-port <port-number>
is-vacant-port () {
  PORT_ID=$( port-id $1 )
  [ -n "$@" ] && echo "false" || echo "true"
}

# kill-port <port-id>
kill-port () {
  echo $(port-id $1) | xargs kill -KILL
}

ext-find () {
  pattern="[A-Za-z\/]\+\.$1$"
  files=$( glob "$2" )
  echo -e "$( find $pattern "$files" )"
}

mksock() {
  python -c "import socket as s; sock = s.socket(s.AF_UNIX); sock.bind('$1')"
}

mod_rewrite_debug() {
  grep "input=\|rewrite " |
  perl -ne "s/^(.*)(?=(rewr|input))//g; print;"
}

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
