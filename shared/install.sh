#!/bin/bash
set -e

QS_DIR="$HOME/.config/quickshell"
REPOS=(
    "quickshell-shared"
    "quickshell-barra"
    "quickshell-wallclock"
    "quickshell-calendar"
    "quickshell-launcher"
)

echo "=== Quickshell Setup ==="

# Check dependencies
for cmd in qs cava mpv sensors; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "[WARN] '$cmd' not found. Install it before using."
    fi
done

# Check mpv-mpris plugin
if ! find /usr -name "mpris.so" 2>/dev/null | grep -q mpv; then
    echo "[WARN] mpv-mpris plugin not found. Music controls won't work without it."
fi

# Create base directory
mkdir -p "$QS_DIR"

# Clone repos
for repo in "${REPOS[@]}"; do
    target="$QS_DIR/${repo#quickshell-}"
    if [ -d "$target/.git" ]; then
        echo "[SKIP] $repo already exists at $target"
    else
        echo "[CLONE] $repo -> $target"
        git clone "https://github.com/Brextal/$repo.git" "$target"
    fi
done

# Create symlinks for shared/
for module in barra wallclock calendar launcher; do
    link="$QS_DIR/$module/shared"
    target="$QS_DIR/shared"
    if [ -L "$link" ]; then
        echo "[SKIP] $module/shared symlink exists"
    elif [ -d "$link" ]; then
        echo "[SKIP] $module/shared is a directory (not a symlink)"
    else
        echo "[LINK] $module/shared -> ../shared"
        ln -s "$target" "$link"
    fi
done

echo ""
echo "=== Done ==="
echo "Add to your hyprland.conf:"
echo "  source = ~/.config/quickshell/barra/hypr/barra.conf"
echo "  source = ~/.config/quickshell/barra/hypr/lookandfeel.conf"
echo "  source = ~/.config/quickshell/calendar/hypr/calendar.conf"
