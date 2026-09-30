#!/usr/bin/env bash
# Links these dotfiles into place. Safe to run more than once.
# Backs up anything it replaces as <file>.bak-<timestamp>.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok       $dest (already linked)"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.bak-$TS"
    echo "backup   $dest -> $dest.bak-$TS"
  fi
  ln -s "$src" "$dest"
  echo "linked   $dest -> $src"
}

# Ghostty (macOS config location)
link "$DOTFILES/ghostty/config.ghostty" \
  "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"

# zsh: add one source line to ~/.zshrc instead of replacing it
ZSHRC="$HOME/.zshrc"
LINE="source \"$DOTFILES/zsh/herdr.zsh\""
touch "$ZSHRC"
if grep -qF "$LINE" "$ZSHRC"; then
  echo "ok       $ZSHRC (already sources herdr.zsh)"
else
  cp -p "$ZSHRC" "$ZSHRC.bak-$TS"
  printf '\n# dotfiles: herdr/Ghostty shell settings\n%s\n' "$LINE" >> "$ZSHRC"
  echo "updated  $ZSHRC (backup: $ZSHRC.bak-$TS)"
fi

echo
echo "Done. In Ghostty press cmd+shift+, to reload, then open a new shell."
