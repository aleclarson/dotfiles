[[ -f ~/.config/gh/token ]] && export NODE_AUTH_TOKEN="$(<~/.config/gh/token)"

##################
# $PATH variable #
##################

typeset -U path PATH

export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"
export PNPM_HOME="$HOME/dev/.pnpm"

path=(
  /opt/homebrew/bin
  /opt/homebrew/opt/openjdk/bin
  /opt/homebrew/opt/rustup/bin
  /opt/homebrew/opt/postgresql@17/bin
  "$GOBIN"
  "$PNPM_HOME"
  "$HOME/.bun/bin"
  "$HOME/.pub-cache/bin"
  "$HOME/dev/bin"
  "$HOME/.local/bin"
  $path
)

# Added by Windsurf
[[ -d "$HOME/.codeium/windsurf/bin" ]] && path=("$HOME/.codeium/windsurf/bin" $path)

###################
# Other variables #
###################

export PKG_CONFIG_PATH="/usr/local/opt/icu4c@76/lib/pkgconfig:$PKG_CONFIG_PATH"

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export GRADLE_USER_HOME="$HOME/dev/Library/gradle"

if [[ -d "$ANDROID_HOME/ndk" ]]; then
  ndk_version="$(ls -1 "$ANDROID_HOME/ndk" 2>/dev/null | sort | tail -n 1)"
  if [[ -n "$ndk_version" ]]; then
    export NDK_HOME="$ANDROID_HOME/ndk/$ndk_version"
    path=("$NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin" $path)
  fi
  unset ndk_version
fi

[[ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ]] && path=("$ANDROID_HOME/cmdline-tools/latest/bin" $path)

command -v mkcert >/dev/null 2>&1 && export REQUESTS_CA_BUNDLE="$(mkcert -CAROOT)/rootCA.pem"

# https://github.com/okbob/pspg
export PSQL_PAGER='pspg -X -b'

# Preferred CLI editor
export EDITOR="/opt/homebrew/bin/nvim"

#######################
# Interactive options #
#######################

if [[ $- =~ i ]]; then
  ##############
  # ZSH config #
  ##############

  if command -v brew >/dev/null 2>&1; then
    fpath+=("$(brew --prefix)/share/zsh/site-functions")
  fi

  plugins=(z fzf)

  export ZSH="$HOME/.oh-my-zsh"
  export DISABLE_AUTO_UPDATE=true
  export DISABLE_LS_COLORS=true
  export DISABLE_MAGIC_FUNCTIONS=true
  [[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

  # Assume `cd` when executing a directory
  setopt autocd

  # Expand "{1-3}.png" to "1.png 2.png 3.png"
  setopt brace_ccl

  # https://github.com/sindresorhus/pure
  autoload -U promptinit
  promptinit
  prompt pure

  # See here: https://github.com/ohmyzsh/ohmyzsh/issues/449#issuecomment-1466968
  unsetopt extendedglob

  ###############
  # Git related #
  ###############

  alias g="git"
  alias ga="git add"
  alias gap="git add -p"
  alias gp="git push"
  alias gpl="git pull"
  alias gb="git branch"
  alias gc="git commit"
  alias gd="git diff"
  alias gds="git diff --staged"
  alias gl="git log --oneline -p"
  alias gr="git rebase"
  alias gs="git status"
  alias gf="git fetch"
  alias co="git checkout"
  alias gcp="git cherry-pick --continue"
  alias amend="git commit --amend --no-edit"
  alias gcm="git-commit-message"
  alias diffb='git show $(git merge-range)'

  # Shows new changes in a specific file.
  alias fdiff="git diff HEAD --"

  # Reverts a specific file back to the HEAD.
  alias revert="git checkout HEAD --"

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

  #################
  # Miscellaneous #
  #################

  alias p="pnpm"
  alias bw="pnpm boardwaves"
  alias adb="$ANDROID_HOME/platform-tools/adb"
  alias vim="nvim"

  # Go up two directories
  alias ...="cd ../.."

  alias pi-fast="pi --model 'github-copilot/gemini-3-flash-preview' --thinking high"
  alias pi-slow="pi --model 'github-copilot/gemini-3.1-pro-preview' --thinking high"
  alias pi-sonnet="pi --model 'github-copilot/claude-sonnet-4.6' --thinking medium"
  alias pi-codex="pi --model 'openai-codex/gpt-5.3-codex' --thinking high"
  alias pi-speckle="pi --subagent speckle --model 'openai-codex/gpt-5.4' --thinking high"

  command -v goddard >/dev/null 2>&1 && alias god=goddard

  # Safe remove
  command -v safe-rm >/dev/null 2>&1 && alias rm="safe-rm"

  # Unsafe recursive remove
  alias rm!="/bin/rm -rf"

  # Open in text editor
  command -v code >/dev/null 2>&1 && alias edit="code"

  # Ripgrep with max line preview
  alias rgc="rg --max-columns=100 --max-columns-preview"

  # File scaffolding
  [[ -f "$HOME/dev/bin/fileform" ]] && alias ff="source ~/dev/bin/fileform"

  alias inspect='NODE_OPTIONS="--inspect --enable-source-maps"'
  alias inspect-brk='NODE_OPTIONS="--inspect-brk --enable-source-maps"'

  # bun completions
  [[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

  command -v wt >/dev/null 2>&1 && eval "$(command wt config shell init zsh)"
  command -v daemon >/dev/null 2>&1 && source <(daemon completion zsh)
  [[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.dart-cli-completion/zsh-config.zsh"
  command -v git-wt >/dev/null 2>&1 && eval "$(command git-wt config shell init zsh)"
fi

#############
# Functions #
#############

git-cc() {
  if [ $# -ge 3 ] && [[ ! $3 =~ ^- ]]; then
    local type=$1
    local scope=$2
    local msg=$3
    if [[ $type == *"!" ]]; then
      type=${type%?}
      git commit -m "$type($scope)!: $msg" "${@:4}"
    else
      git commit -m "$type($scope): $msg" "${@:4}"
    fi
  elif [ $# -ge 2 ]; then
    git commit -m "$1: $2" "${@:3}"
  else
    return 1
  fi
}

# Create a single commit git-patch and pbcopy it.
pbpatch() {
  if [ $# -eq 1 ]; then
    git format-patch --stdout -1 "$1" | pbcopy
  elif [ $# -eq 0 ]; then
    pbpaste | git am
  fi
}

git-reword() {
  git commit --fixup "reword:$1" &&
    GIT_EDITOR="cat" git rebase --autosquash -i "$1^"
}

# gcm [commit:-HEAD]
git-commit-message() {
  git log "${1:-HEAD}^..${1:-HEAD}" --pretty=%B
}

# tagd <tag> <commit> ...
git-tag-back() {
  GIT_COMMITTER_DATE="$(git show "$2" --format=%aD | head -1)" \
    git tag "$@"
}

# tagf <remote> <tag>
git-tag-fetch() {
  git fetch "$1" "refs/tags/$2:refs/tags/$2" --no-tags "${@:3}"
}

# tagd <tag>
git-tag-delete() {
  git tag -d "$1"
  git push origin ":$1"
}

# tagda (local only)
git-tag-delete-all() {
  git tag -d $(git tag -l)
}

# branchd <branch-name>
git-branch-delete() {
  git branch -D "$1"
  git push origin --delete "$1"
}

git-wip() {
  git add -A
  git commit -m "wip"
  git push
}

random_str() {
  LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w "${1:-16}" | head -n 1
}

url_decode() {
  node -e 'console.log(decodeURIComponent(process.argv[1]))' "$1"
}

url_encode() {
  node -e 'console.log(encodeURIComponent(process.argv[1]))' "$1"
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
  . ~/.nvm/nvm.sh && nvm "$@"
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
