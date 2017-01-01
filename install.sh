#!/bin/sh

# Thanks to Dries Vints! https://driesvints.com

echo "Setting up your machine.."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
# TODO: install bare minimum
brew tap homebrew/bundle
brew bundle --file=brew/base/Brewfile
brew bundle --file=brew/zsh/Brewfile
brew bundle --file=brew/bin/Brewfile
brew bundle --file=brew/apps/Brewfile
brew bundle --file=brew/services/Brewfile

# Make ZSH the default shell environment
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)

# Install zim
if test ! -d $HOME/.zim; then
  git clone --recursive https://github.com/Eriner/zim.git $HOME/.zim
fi

# Link .rc files via stow
stow zsh

# Install Solarized theme for iTerm2
rake install

# Install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Set macOS preferences
# We will run this last because this will reload the shell
source osx/.macos
