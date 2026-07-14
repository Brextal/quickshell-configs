#!/bin/bash
set -e

QS_DIR="$HOME/.config/quickshell"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Quickshell Configs Setup ==="

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

# Create target directory
mkdir -p "$QS_DIR"

# Copy modules
for module in shared barra wallclock calendar launcher; do
    if [ -d "$QS_DIR/$module/.git" ] || [ -f "$QS_DIR/$module/shell.qml" ]; then
        echo "[SKIP] $module already exists at $QS_DIR/$module"
    else
        echo "[COPY] $module -> $QS_DIR/$module"
        cp -r "$SCRIPT_DIR/$module" "$QS_DIR/$module"
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
echo ""
echo "Add to your hyprland.conf:"
echo "  source = ~/.config/quickshell/barra/hypr/barra.conf"
echo "  source = ~/.config/quickshell/barra/hypr/lookandfeel.conf"
echo "  source = ~/.config/quickshell/calendar/hypr/calendar.conf"
echo ""
echo "Start with:"
echo "  qs -p ~/.config/quickshell/barra/shell.qml"
echo "  qs -p ~/.config/quickshell/wallclock/shell.qml"
echo "  qs -p ~/.config/quickshell/calendar/shell.qml"
