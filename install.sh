#!/bin/bash

# Dotfiles installation script
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}Setting up dotfiles from ${DOTFILES_DIR}${NC}"

# Function to create symlinks
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -L "$target" ]; then
        echo -e "${YELLOW}Removing existing symlink: $target${NC}"
        rm "$target"
    elif [ -f "$target" ] || [ -d "$target" ]; then
        echo -e "${YELLOW}Backing up existing file: $target${NC}"
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    echo -e "${GREEN}Creating symlink: $target -> $source${NC}"
    ln -s "$source" "$target"
}

# Create necessary directories
echo -e "${BLUE}Creating necessary directories...${NC}"
mkdir -p ~/.config/{tmux,nvim}
mkdir -p ~/.config/git

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Oh My Zsh if not installed
if [ ! -d ~/.oh-my-zsh ]; then
    echo -e "${BLUE}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k if not installed
if [ ! -d ~/.oh-my-zsh/themes/powerlevel10k ]; then
    echo -e "${BLUE}Installing Powerlevel10k...${NC}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
fi

# Install zsh plugins
echo -e "${BLUE}Installing zsh plugins...${NC}"
if [ ! -d ~/.oh-my-zsh/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
fi

if [ ! -d ~/.oh-my-zsh/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
fi

# Install TPM (Tmux Plugin Manager) if not installed
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo -e "${BLUE}Installing TPM (Tmux Plugin Manager)...${NC}"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Create symlinks
echo -e "${BLUE}Creating symlinks...${NC}"

# Tmux
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# Neovim
create_symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"

# Zsh
create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"

# Git
create_symlink "$DOTFILES_DIR/config/git/gitconfig" "$HOME/.gitconfig"
if [ -f "$DOTFILES_DIR/config/git/gitignore_global" ]; then
    create_symlink "$DOTFILES_DIR/config/git/gitignore_global" "$HOME/.gitignore_global"
fi

# Install fonts
echo -e "${BLUE}Installing fonts...${NC}"
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono font-fira-code-nerd-font font-meslo-lg-nerd-font

# Install useful tools
echo -e "${BLUE}Installing useful tools...${NC}"
brew install tmux git fzf bat lsd delta neovim ripgrep fd

echo -e "${GREEN}✅ Dotfiles installation complete!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Restart your terminal"
echo -e "2. Install tmux plugins: Open tmux and press prefix + I"
echo -e "3. Configure iTerm2: Import settings from ~/dotfiles/iterm2/"
echo -e "4. Run 'p10k configure' to set up your prompt"
echo -e "5. Open Neovim to install/update plugins automatically"

