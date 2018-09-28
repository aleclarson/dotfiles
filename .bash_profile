[[ -s ~/.bashrc ]] && source ~/.bashrc

# Auto-completion settings
set show-all-if-ambiguous on
set completion-ignore-case on

#######################
# Interactive options #
#######################
[[ $- == *i* ]] || return 0

# Assume `cd` when executing a directory
shopt -s autocd 2>/dev/null

# Recursive globbing
shopt -s globstar

# Keep $ROWS/$COLUMNS updated
shopt -s checkwinsize

# Treat @ like any other character
shopt -u hostcomplete
