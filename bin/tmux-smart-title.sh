#!/usr/bin/env bash
# tmux-smart-title.sh — setzt für EIN tmux-Window einen sinnvollen, kurzen Titel.
#
# WARUM (Owner-Direktive 2026-06-15): manuell gestartete Windows hießen alle
#   "claude"/"bash" — nutzlos beim Window-Wechsel. Dieser Helper leitet einen
#   sprechenden Titel aus laufendem Vordergrund-Prozess + Arbeitsverzeichnis ab,
#   gekürzt auf MAXLEN, und respektiert bewusst gesetzte Titel (Loop-Spawner).
#
# Aufruf via tmux-Hooks (siehe .tmux.conf): after-new-window, pane-focus-in,
#   after-rename-window. Argument: die Window-ID ("#{window_id}").
#
# Logik:
#   - Ist der aktuelle Name "sinnvoll" (kein generischer Prozess-/Shell-Name)?
#     → in Ruhe lassen (z.B. Loop-Slug vom Spawner, oder vom User manuell gesetzt).
#   - Sonst: Titel = "<proc>·<cwd-basename>", gekürzt. Bei reiner Shell nur cwd.
set -euo pipefail

WIN="${1:-}"
[[ -n "$WIN" ]] || exit 0
MAXLEN="${TMUX_TITLE_MAXLEN:-18}"

# Generische Namen, die NICHTS aussagen → dürfen überschrieben werden.
GENERIC='^(bash|zsh|sh|fish|claude|node|codex|python|python3|tmux|-bash|-zsh)$'

# HARTE SPERRE (Owner-Direktive 2026-06-15): vom Orko-Hub gespawnte Loop-Windows
# tragen die User-Option @orko_locked=1. Diese Windows sind IDEMPOTENT + UNVERÄNDERBAR
# — der Helper fasst sie NIE an, sonst kommt der Hub (Window-Index-Targeting) durcheinander.
locked="$(tmux show-options -wqv -t "$WIN" '@orko_locked' 2>/dev/null || echo '')"
[[ "$locked" == "1" ]] && exit 0

cur="$(tmux display-message -p -t "$WIN" '#{window_name}' 2>/dev/null || echo '')"
# Bewusst gesetzter, sprechender Name → nicht anfassen.
if [[ -n "$cur" && ! "$cur" =~ $GENERIC ]]; then exit 0; fi

# Aktiver Pane des Windows: Vordergrund-Kommando + cwd.
pane="$(tmux display-message -p -t "$WIN" '#{pane_id}' 2>/dev/null || echo '')"
[[ -n "$pane" ]] || exit 0
proc="$(tmux display-message -p -t "$pane" '#{pane_current_command}' 2>/dev/null || echo '')"
cwd="$(tmux display-message -p -t "$pane" '#{pane_current_path}' 2>/dev/null || echo '')"
base="$(basename "${cwd:-$HOME}")"
[[ "$base" == "$(basename "$HOME")" ]] && base="~"

# Titel bauen: Prozess·Verzeichnis, Shell → nur Verzeichnis.
case "$proc" in
  bash|zsh|sh|fish|-bash|-zsh|"") title="$base" ;;
  claude) title="claude·$base" ;;   # Claude-Session → klar markiert + wo
  node)   title="node·$base" ;;
  *)      title="$proc·$base" ;;
esac

# Kürzen (Ellipsis), damit die Statusbar nicht überläuft.
if (( ${#title} > MAXLEN )); then title="${title:0:$((MAXLEN-1))}…"; fi

tmux rename-window -t "$WIN" "$title" 2>/dev/null || true
