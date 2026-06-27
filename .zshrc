unsetopt EXTENDED_GLOB
unsetopt KSH_GLOB
setopt NO_NOMATCH

# Treat path separators, dots, hyphens, and underscores as word boundaries.
WORDCHARS=${WORDCHARS//[\/._-]}

export PNPM_HOME="$HOME/dev/.pnpm"

path=(
  /opt/homebrew/bin
  $HOME/dev/bin
  $HOME/dev/.pnpm/bin
  $PNPM_HOME
  $HOME/.cargo/bin
  $HOME/.bun/bin
  $HOME/.deno/bin
  $HOME/.local/bin
  ${path[@]}
)

# Node auth token for private npm packages
export NODE_AUTH_TOKEN="$(cat ~/.config/gh/token)"

# Preferred CLI editor
export EDITOR="/opt/homebrew/bin/nvim"
alias vim="nvim"

# Go up two directories
alias ...="cd ../.."

-() { cd -; }

alias p="pnpm"
alias b="bun"

# Safe remove
alias rm="safe-rm"

# Unsafe recursive remove
alias rm!="/bin/rm -rf"

alias sb="sprint-branch"
alias sprint="sprint-branch"
alias rs="review-sync"
alias review="review-sync"

alias amend="git commit --amend --no-edit"
alias lastcommit="git show HEAD"

alias g="git"
alias ga="git add"
alias gap="git add -p"
alias gp="git push"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline"
alias gm="git merge --ff-only"
alias gr="git rebase"
alias gs="git status"
alias gf="git fetch"
alias co="git checkout"
alias gcp="git cherry-pick --continue"

# git copy-commit-message [commit:-HEAD]
git-copy-commit-message() {
  git log "$1^..$1" --pretty=%B
}

# git merge-detached <target-branch>
git-merge-detached() {
  local temp="tmp-merge-$$"
  local target="${1:?usage: git-merge-detached <target-branch>}"
  local original_dir="$PWD"
  local target_worktree
  shift

  target_worktree=$(git worktree list --porcelain | awk -v branch="refs/heads/$target" '
    /^worktree / { path = substr($0, 10) }
    $0 == "branch " branch { print path; exit }
  ')

  git branch "$temp" HEAD || return

  if [[ -n "$target_worktree" ]]; then
    cd "$target_worktree" || {
      git branch -D "$temp"
      return 1
    }
  else
    git switch "$target" || {
      git branch -D "$temp"
      return 1
    }
  fi

  git merge --ff-only "$temp" || {
    if [[ -n "$target_worktree" ]]; then
      cd "$original_dir"
    else
      git switch -
    fi
    git branch -D "$temp"
    return 1
  }
  git branch -d "$temp" || {
    if [[ -n "$target_worktree" ]]; then
      cd "$original_dir"
    else
      git switch -
    fi
    git branch -D "$temp"
    return 1
  }

  if [[ -n "$target_worktree" ]]; then
    cd "$original_dir"
  else
    git switch -  # returns you to the previous detached HEAD
  fi
}

alias pi-fast="pi --model 'openai-codex/gpt-5.5' --thinking low"
alias pi-slow="pi --model 'openai-codex/gpt-5.5' --thinking xhigh"

# Start configuration added by Zim Framework install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# --------------------
# Module configuration
# --------------------

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh
# }}} End configuration added by Zim Framework install

# bun completions
[ -s "/Users/alec/.bun/_bun" ] && source "/Users/alec/.bun/_bun"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# Keep shell history session-local after reading the existing file once.
# Placed near the end to override framework defaults.
setopt APPEND_HISTORY
unsetopt INC_APPEND_HISTORY SHARE_HISTORY
fc -R $HISTFILE
