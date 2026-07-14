# Quickshell Configs

Suite completa de widgets para **Hyprland** con [Quickshell](https://quickshell.outfoxxed.me/). Colores dinámicos vía [pywal](https://github.com/dylanaraps/pywal).

## Módulos

| Módulo | Descripción | Atajo |
|---|---|---|
| **barra** | Panel flotante tipo isla con control de volumen, brillo, red, bluetooth, power menu y widget musical | Super+Escape |
| **wallclock** | Reloj flotante + panel musical con carátula circular giratoria y equalizer CAVA | Super+K |
| **calendar** | Calendario con clima (Open-Meteo API) | Super+D |
| **launcher** | App launcher con carrusel y búsqueda | Super+L |

## Instalación rápida

```bash
git clone https://github.com/Brextal/quickshell-configs.git /tmp/quickshell-configs
/tmp/quickshell-configs/install.sh
```

## Instalación manual

```bash
git clone https://github.com/Brextal/quickshell-configs.git ~/.config/quickshell-configs
cp -r ~/.config/quickshell-configs/{shared,barra,wallclock,calendar,launcher} ~/.config/quickshell/
ln -s ~/.config/quickshell/shared ~/.config/quickshell/barra/shared
ln -s ~/.config/quickshell/shared ~/.config/quickshell/wallclock/shared
ln -s ~/.config/quickshell/shared ~/.config/quickshell/calendar/shared
ln -s ~/.config/quickshell/shared ~/.config/quickshell/launcher/shared
```

## Configuración de Hyprland

Agregá al final de `~/.config/hypr/hyprland.conf`:

```conf
source = ~/.config/quickshell/barra/hypr/barra.conf
source = ~/.config/quickshell/barra/hypr/lookandfeel.conf
source = ~/.config/quickshell/calendar/hypr/calendar.conf
```

## Dependencias

### Requeridas
- [Quickshell](https://quickshell.outfoxxed.me/) 0.3.0+
- Hyprland
- Qt6 (QtQuick, QtQuick.Window, Qt5Compat.GraphicalEffects)
- [pywal](https://github.com/dylanaraps/pywal) o [pywal16](https://github.com/eylles/pywal16)
- Nerd Fonts

### Para el widget musical
- `mpv` + `mpv-mpris` — reproducción
- [CAVA](https://github.com/karlstav/cava) — equalizer

### Para la barra
- `nmcli` — red
- `brightnessctl` — brillo
- `pactl` — volumen
- `zenity` — selector de carpetas
- `hyprlock` — bloquear sesión

### Para el calendario
- `curl` — fetch del clima

### Para stats del sistema
- `sensors` (lm_sensors) — temperatura
- `free`, `df` — RAM y disco

## Atajos de teclado

| Atajo | Acción |
|---|---|
| Super+Escape | Abrir/cerrar panel de control |
| Super+K | Abrir/cerrar panel musical |
| Super+D | Abrir/cerrar calendario |
| Super+L | Abrir/cerrar launcher |
| Escape | Cerrar panel |

## Estructura

```
~/.config/quickshell/
├── shared/           # Pywal.qml — paleta de colores compartida
├── barra/            # Panel principal + secciones
├── wallclock/        # Reloj + widget musical + stats
├── calendar/         # Calendario + clima
└── launcher/         # App launcher
```

## Recargar después de cambios

Cada módulo tiene su script de recarga:

```bash
~/.config/quickshell/barra/reload.sh
~/.config/quickshell/wallclock/reload.sh
~/.config/quickshell/calendar/reload.sh
~/.config/quickshell/launcher/reload.sh
```

## Licencia

MIT
