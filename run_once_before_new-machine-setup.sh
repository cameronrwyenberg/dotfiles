#!/bin/sh

brew install --cask kitty
brew install neovim

#Installing lazyvim into neovim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

#Intalls Rust and Cargo
curl https://sh.rustup.rs -sSf | sh

cargo install macchina

brew install bottom
brew install fzf
brew install chezmoi
brew install starship
brew install jesseduffield/lazygit/lazygit
