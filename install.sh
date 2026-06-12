#!/usr/bin/env bash
# ~/.dotfiles/install.sh — idempotent, symlinkt nach $HOME, bash-fokussiert, kein Netz.
# Bestehende Nicht-Symlink-Dateien werden gesichert (.bak.<ts>), NIE still ueberschrieben.

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
DOTFILES="$PWD"
TS="$(date +%Y%m%d-%H%M%S)"

# Dateien, die als Symlink nach $HOME gelegt werden
LINKS=(.tmux.conf)

link() {
    local src="$DOTFILES/$1" dst="$HOME/$1"
    # schon korrekter Symlink -> nichts tun (idempotent)
    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
        echo "  ok   $1 (bereits verlinkt)"
        return
    fi
    # existierende echte Datei sichern, nie ueberschreiben
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "$dst.bak.$TS"
        echo "  bak  $1 -> $1.bak.$TS"
    fi
    ln -sfn "$src" "$dst"
    echo "  link $1"
}

echo "Dotfiles -> $HOME (Symlinks)"
for f in "${LINKS[@]}"; do link "$f"; done

# .bashrc-Hook: genau EINE geguardete Zeile, sourct .my_bash (das laedt .my_aliases)
HOOK='[ -r ~/.dotfiles/.my_bash ] && . ~/.dotfiles/.my_bash'
if ! grep -qF "$HOOK" "$HOME/.bashrc" 2>/dev/null; then
    printf '\n# dotfiles\n%s\n' "$HOOK" >> "$HOME/.bashrc"
    echo "  hook .bashrc -> .my_bash"
else
    echo "  ok   .bashrc-Hook"
fi

# Doctor: tmux-Version warnen (Config braucht >= 3.2)
if command -v tmux >/dev/null 2>&1; then
    ver="$(tmux -V | grep -oE '[0-9]+\.[0-9]+' | head -1)"
    awk -v v="$ver" 'BEGIN{ if (v+0 < 3.2) exit 1 }' \
        || echo "  WARN tmux $ver < 3.2 — Config nutzt moderne Syntax, ggf. alte Config aus git-History"
fi

echo "Fertig. Neue Shell oeffnen oder: source ~/.bashrc  +  tmux source ~/.tmux.conf"
