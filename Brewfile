# Brewfile — packages these dotfiles expect, plus daily CLI staples.
#
# New machine:
#   brew bundle --file ~/path/to/dotfiles/Brewfile
#
# Everything in .zshrc/.gitconfig degrades gracefully if a package is
# missing, so this is the install record, not a hard dependency list.

# referenced by .zshrc
brew "direnv"        # per-directory env vars (.envrc)
brew "fzf"           # ctrl-r fuzzy history, ctrl-t fuzzy files
brew "zoxide"        # z <fragment> directory jumping
brew "starship"      # prompt
brew "unar"          # backs the unrar alias
brew "opentofu"      # backs the tf alias

# referenced by .gitconfig
brew "git-delta"     # diff pager
brew "git-lfs"       # lfs filters
brew "gh"            # credential helper

# daily staples
brew "ripgrep"
brew "jq"
brew "btop"
brew "just"
brew "uv"

# starship prompt glyphs in the terminal
cask "font-jetbrains-mono-nerd-font"
