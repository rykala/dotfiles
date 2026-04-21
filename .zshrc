# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Allows to use ctrl+c/z/d
bindkey -e

# Thrash
alias rm=trash

# Custom aliases
alias pn=pnpm
alias zshconfig="vim ~/.zshrc"

alias cl="CLAUDE_CODE_NO_FLICKER=1 claude"

## k8s
autoload -U compinit && compinit
source <(kubectl completion zsh)
alias kctx="kubectx"
alias kns="kubens"

# VIM
alias vim=nvim

# Kubectl
alias k=kubectl
compdef k=kubectl

# Docker
source /Users/rykala/.docker/init-zsh.sh || true # Added by Docker Desktop

# Volta
path+=("$HOME/.volta/bin")

# PSQL
path+=("/opt/homebrew/opt/libpq/bin")

# Eza 
alias ls='eza -F -gh --group-directories-first --git-ignore --icons=always --color-scale all --hyperlink'
alias lh='ls -d .*'
alias lD='ls -D'
alias lc='ls -1'

alias ll='ls -l'
alias la='ll -a'

if [[ "$EZA_ENABLE_SORT_ALIASES" = 1 ]]; then
  alias lA='ll --sort=acc'
  alias lC='ll --sort=cr'
  alias lM='ll --sort=mod'
  alias lS='ll --sort=size'
  alias lX='ll --sort=ext'
  alias llm='lM'
fi

if [[ "$EZA_ENABLE_EXTENDED_ALIASES" = 1 ]]; then
  alias l='la -a'
  alias lsa='l'
  alias lx='l -HimUuS'
  alias lxa='lx -Z@'
fi

alias lt='ls -T'
alias tree=lt

# Starship
export STARSHIP_CONFIG="$HOME/.starship.toml"
eval "$(starship init zsh)"

# Zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# pnpm
export PNPM_HOME="/Users/rykala/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Added by Antigravity
export PATH="/Users/rykala/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Zoxide (must be last)
eval "$(zoxide init --cmd cd zsh)"
