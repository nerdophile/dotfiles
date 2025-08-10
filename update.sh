#!/bin/bash

# Update dotfiles from current system
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Updating dotfiles..."

# Update tmux config
if [ -f ~/.config/tmux/tmux.conf ]; then
    cp ~/.config/tmux/tmux.conf "$DOTFILES_DIR/tmux/tmux.conf"
    echo "✅ Updated tmux config"
fi

# Update zsh configs
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc "$DOTFILES_DIR/zsh/zshrc"
    echo "✅ Updated zsh config"
fi

if [ -f ~/.p10k.zsh ]; then
    cp ~/.p10k.zsh "$DOTFILES_DIR/zsh/p10k.zsh"
    echo "✅ Updated p10k config"
fi

# Update git config
if [ -f ~/.gitconfig ]; then
    cp ~/.gitconfig "$DOTFILES_DIR/config/git/gitconfig"
    echo "✅ Updated git config"
fi

echo "🎉 Dotfiles updated! Don't forget to commit and push changes."

