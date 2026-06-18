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
| `.my_bash` | `tm`/`battlecat` (kanonische `orko`-Session, Highlander — siehe unten), `tmk`/`gdrop`, PATH, Tool-Hooks (nvm/conda/brew/direnv/zoxide/fzf), Prompt mit `[ssh]`-Marker |
| `.my_aliases` | moderne CLI (eza/bat/rg/fd falls da, sonst Coreutils), git, navigation |
| `install.sh` | idempotenter Symlink-Installer |

## Die kanonische Orko-Session: `tm` / `battlecat`

Ein Wort -> rein in die Werkbank. Beide Befehle teilen **denselben** Helper und
zielen **immer** auf die EINE tmux-Session namens `orko`:

- existiert `orko` -> attach. Sonst -> neu, leer, in `~/orko`.
- **Highlander:** niemals eine zweite Session spawnen (kein `tm <name>`, kein
  Verzeichnis-benanntes `cx` mehr — beides war die Quelle von Session-Wildwuchs).
- Claude startest du **selbst** im Window (`claude` tippen) — kein Auto-Start.

| Befehl | Wo | Wirkung |
|---|---|---|
| `tm` | lokal auf battlecat | attach an `orko` (sonst neu) |
| `battlecat` | lokal auf battlecat | identisch zu `tm` |
| `battlecat` | von WSL2/Laptop | `ssh -t battlecat`, dort dieselbe Highlander-Logik |
| `tmls` | überall | `tmux ls` |
| `bctunnel` | vom Laptop | battlecat-Web-Ports forwarden (Default 3100/8100/…), Strg+C beendet |
| `bcweb` | vom Laptop | `bctunnel` im Hintergrund + Leitivo-Login im Browser; `bcweb stop` beendet |

Mehrere Claude-Instanzen parallel? Innerhalb von `orko` neues Window mit `Ctrl+a c`,
dort `claude`. Wechseln mit `Ctrl+a n` / `Ctrl+a <nummer>`. Eine Session, N Windows.

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
