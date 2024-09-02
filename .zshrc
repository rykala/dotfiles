# ZSH 
ZSH_THEME="robbyrussell"
plugins=(
    brew
    colored-man-pages
    colorize
    direnv
    docker
    docker-compose
    git
    kubectl
    macos
    httpie
    volta
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# dump OMZ files to cache
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
export ZSH="/Users/rykala/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Allows to use ctrl+c/z/d
bindkey -e

# Custom aliases
alias pn="pnpm"
alias zshconfig="vim ~/.zshrc"

## k8s
source <(kubectl completion zsh)
alias kctx="kubectx"
alias kns="kubens"
autoload -U compinit && compinit

# VIM
alias vim=nvim

# Kubectl
alias k=kubectl
complete -F __start_kubectl k

# Docker
source /Users/rykala/.docker/init-zsh.sh || true # Added by Docker Desktop

# Volta
path+=("$HOME/.volta/bin")

# PSQL
path+=("/opt/homebrew/opt/libpq/bin")

# Eza 
alias ls='eza -F -gh --group-directories-first --git --git-ignore --icons=always --color-scale all --hyperlink'
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

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# Starship
export STARSHIP_CONFIG="$HOME/.starship.toml"
eval "$(starship init zsh)"
