export PATH="$HOME/.local/bin:$PATH"

alias ll='ls -la '
alias unrar='unar '
# opentofu similar to terraform just more opensource
alias tf='tofu '
set -o vi
screen -ls

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section

# uv
#eval "$(uv generate-shell-completion zsh)"

# direnv
eval "$(direnv hook zsh)"

if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  autoload -Uz compinit
  compinit
fi

#To use vllm, activate the virtual environment:
# source $HOME/.venv-vllm-metal/bin/activate

#Or add the venv to your PATH:
export PATH="$HOME/.venv-vllm-metal/bin:$PATH"

# allow zsh commands that end with a # something here to work
setopt interactivecomments

# OpenClaw Completion
[ -f "$HOME/.openclaw/completions/openclaw.zsh" ] && source "$HOME/.openclaw/completions/openclaw.zsh"

# history — zsh default keeps only 1000 lines; fzf ctrl-r needs more to be useful
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY        # merge history across open shells
setopt HIST_IGNORE_ALL_DUPS # drop older duplicates of a repeated command
setopt HIST_IGNORE_SPACE    # a leading space keeps a command out of history

# fzf — ctrl-r fuzzy history search, ctrl-t fuzzy file insert
command -v fzf >/dev/null && source <(fzf --zsh)

# zoxide — frecency-ranked directory jumping: z <fragment>
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# starship prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# machine-local overrides (homelab, host-specific) — untracked, see ~/.zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# secrets
[[ -f ~/.env ]] && source ~/.env
