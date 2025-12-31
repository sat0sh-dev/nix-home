#!/usr/bin/env sh
set -eu

ZSH_PATH="$(command -v zsh)"

if [ -z "$ZSH_PATH" ]; then
  echo "zsh not found in PATH. Run Home Manager first."
  exit 1
fi

if [ "$SHELL" != "$ZSH_PATH" ]; then
  echo "Changing login shell to $ZSH_PATH"
  chsh -s "$ZSH_PATH"
  echo "Please log out and log in again."
else
  echo "Login shell already set to zsh"
fi
