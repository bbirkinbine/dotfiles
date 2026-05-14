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
