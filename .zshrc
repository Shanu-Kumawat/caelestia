# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set zinit and plugins directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

if [ -e /home/shanu/.nix-profile/etc/profile.d/nix.sh ]; then . /home/shanu/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/shanu/.dart-cli-completion/zsh-config.zsh ]] && . /home/shanu/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

#-----------------------------------------------------------------------
#                            ENVIRONMENT
#-----------------------------------------------------------------------

# Set the default editor for command-line tools
export EDITOR=nvim
export VISUAL=nvim

# Specify path to Chrome for tools like Flutter
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

# Set the home directory for the Android SDK
export ANDROID_HOME=$HOME/Android/Sdk

#-----------------------------------------------------------------------
#                                PATH
#-----------------------------------------------------------------------

# Android SDK
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

# Flutter & Dart
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"

# Ruby Gems
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.3.0/bin"

# Dynamically add the latest Android build-tools to the path
if [ -d "$ANDROID_HOME/build-tools" ]; then
  latest_build_tools=$(find "$ANDROID_HOME/build-tools" -maxdepth 1 -type d | sort -r | head -n 1)
  export PATH="$PATH:$latest_build_tools"
fi

