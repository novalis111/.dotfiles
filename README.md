# .dotfiles

Schlankes bash + tmux Setup. Modern (tmux >= 3.2), idempotent, Symlinks statt Kopien.

## Install

```bash
git clone git@github.com:novalis111/.dotfiles.git ~/.dotfiles && bash ~/.dotfiles/install.sh
```

`install.sh` ist idempotent: legt `~/.tmux.conf` als Symlink an (bestehende echte Datei
wird nach `.bak.<ts>` gesichert, nie still ueberschrieben) und haengt einen geguardeten
Hook an `~/.bashrc`, der `.my_bash` (+ `.my_aliases`) sourct.

## Inhalt

| Datei | Zweck |
|---|---|
| `.tmux.conf` | Prefix `C-a`, Pane-Switch `Shift+Pfeil` (+ `prefix h/j/k/l`), Anti-Flicker (sync/escape-time 0/tmux-256color), OSC52-Clipboard |
| `.my_bash` | `tm`/`tmk`/`gdrop`, PATH, Tool-Hooks (nvm/conda/brew/direnv/zoxide/fzf), Prompt mit `[ssh]`-Marker |
| `.my_aliases` | moderne CLI (eza/bat/rg/fd falls da, sonst Coreutils), git, navigation |
| `install.sh` | idempotenter Symlink-Installer |

## Updaten

```bash
updot   # git pull + install.sh
```

## Lokale Overrides (nie im Repo)

- `~/.bashrc.local` — Maschinen-spezifische Shell-Config (wird von `.my_bash` gesourct)
- `~/.tmux.local.conf` — Maschinen-spezifische tmux-Config (wird von `.tmux.conf` gesourct)

## tmux-Kurzreferenz

- Prefix: `Ctrl+a` · letztes Fenster: `Ctrl+a Ctrl+a`
- Pane wechseln: `Shift+Pfeil` (oder `Ctrl+a` dann `h/j/k/l`)
- Split: `Ctrl+a -` (horizontal) · `Ctrl+a |` (vertikal)
- Resize: `Ctrl+a Pfeil` (wiederholbar) · Reload: `Ctrl+a r`
- Detach: `Ctrl+a d` · Copy-Mode: `Ctrl+a [`, dann `v` markieren, `y` kopieren (-> System-Clipboard)
