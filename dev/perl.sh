#!/bin/sh
brew bundle --file=brew/perl/Brewfile
echo 'eval "$(plenv init -)"' >> ~/.zshrc
exec zsh -l
plenv install 5.24.0
plenv shell 5.24.0
plenv install-cpanm
plenv rehash
cpanm Carton
plenv rehash
