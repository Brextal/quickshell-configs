# Quickshell Configs

Suite completa de widgets para **Hyprland** con [Quickshell](https://quickshell.outfoxxed.me/). Colores dinámicos vía [pywal](https://github.com/dylanaraps/pywal).

```
~/.config/quickshell/
├── shared/           Paleta de colores pywal (leida desde ~/.cache/wal/colors.json)
├── barra/            Panel flotante tipo isla con secciones
├── wallclock/        Reloj + panel musical con carátula + equalizer
├── calendar/         Calendario con clima
└── launcher/         App launcher con carrusel
```

## Módulos

### barra — Panel de control flotante

Panel estilo **glassmorphism** (fondos blancos traslúcidos, bordes suaves) que aparece como una isla en la parte superior de la pantalla. Se abre con **Super+Escape** o click en el reloj.

| Sección | Función |
|---|---|
| Power grid | Bloquear, Suspender, Hibernar, Reiniciar, Apagar, Cerrar sesión |
| Volumen | Slider de volumen (pactl) |
| Brillo | Slider de brillo (brightnessctl) |
| Red | Conexión actual, redes WiFi disponibles, conectar (nmcli) |
| Bluetooth | Estado y alias del dispositivo |
| Widget musical | Barras animadas + marquee infinito con info del track (MPRIS) |

**Archivos:** `shell.qml` (principal), `VolumeSection.qml`, `BrightnessSection.qml`, `NetworkSection.qml`, `BluetoothSection.qml`, `MusicWidget.qml`, `clock.qml`, `workspaces.qml`

### wallclock — Reloj + panel musical

Widget flotante con **reloj digital grande** en la parte superior y **stats del sistema** (CPU/GPU temp, RAM, disco) en la parte inferior.

El **panel musical** se abre con **Super+K** y tiene:

- **Carátula circular giratoria** — se busca automáticamente en la carpeta del disco (`cover.jpg`, `Cover.jpg`, `folder.jpg`, etc.), sube hasta 3 niveles de directorio. Gira suavemente cuando la música está reproduciendo.
- **Controles** — play/pause, anterior, siguiente, abrir carpeta
- **Equalizer** — visualizer de audio en tiempo real via CAVA (pipe a `/tmp/cava_bars`)
- **Metadata** — artista, título, duración

Los botones anterior/siguiente usan `dbus-send` directo a mpv-mpris (bypass del binding de Quickshell).

**Archivos:** `shell.qml` (principal), `RingArc.qml` (componente de arco), `cava-read.sh` (pipe CAVA), `find-cover.sh` (busca carátula), `stats.sh` (recolecta stats)

### calendar — Calendario con clima

Calendario flotante mensual con información del clima obtenida de [Open-Meteo API](https://open-meteo.com/).

- **Navegación** entre meses
- **Clima** — temperatura actual, máxima/mínima, ícono
- **Día actual** — resaltado con color de pywal
- **Click en día** — muestra detalles

Por defecto usa coordenadas de **Maipu, Chile** (`-33.45, -70.66`). Para cambiar, editá `weather_fetch.sh`.

**Archivos:** `shell.qml` (principal), `CalendarStrip.qml` (franja de días), `DayItem.qml` (item individual), `weather_fetch.sh` (fetch clima)

### launcher — App launcher

Launcher de aplicaciones con diseño de carrusel horizontal y búsqueda por texto.

- **Carrusel** — muestra apps en fila con iconos
- **Búsqueda** — filtra por nombre
- **Preview** — GIF de demo en `demo/`
- Parsea archivos `.desktop` del sistema via `parse-desktop.sh` (Python 3)

**Archivos:** `shell.qml` (principal), `LauncherPanel.qml` (panel con búsqueda), `AppItem.qml` (item visual), `parse-desktop.sh` (parser)

## Instalación rápida

```bash
git clone https://github.com/Brextal/quickshell-configs.git /tmp/quickshell-configs
/tmp/quickshell-configs/install.sh
rm -rf /tmp/quickshell-configs
```

## Instalación manual

```bash
git clone https://github.com/Brextal/quickshell-configs.git ~/.config/quickshell-configs
cp -r ~/.config/quickshell-configs/{shared,barra,wallclock,calendar,launcher} ~/.config/quickshell/
rm -f ~/.config/quickshell/{barra,wallclock,calendar,launcher}/shared
ln -s ../shared ~/.config/quickshell/barra/shared
ln -s ../shared ~/.config/quickshell/wallclock/shared
ln -s ../shared ~/.config/quickshell/calendar/shared
ln -s ../shared ~/.config/quickshell/launcher/shared
```

## Configuración de Hyprland

Agregá al final de `~/.config/hypr/hyprland.conf`:

```conf
source = ~/.config/quickshell/barra/hypr/barra.conf
source = ~/.config/quickshell/barra/hypr/lookandfeel.conf
source = ~/.config/quickshell/calendar/hypr/calendar.conf
```

Esto configura:
- **Autostart** — lanza barra, wallclock y calendar al iniciar sesión
- **Atajos de teclado** — Super+K (musical), Super+D (calendario), Super+Escape (panel)
- **Layerrules** — blur/glassmorphism en las capas de quickshell
- **Look and feel** — blur optimizado para vidrio empañado

## Dependencias

### Requeridas
- [Quickshell](https://quickshell.outfoxxed.me/) 0.3.0+ (`qs` o `quickshell`)
- Hyprland
- Qt6 (QtQuick, QtQuick.Window, Qt5Compat.GraphicalEffects)
- [pywal](https://github.com/dylanaraps/pywal) o [pywal16](https://github.com/eylles/pywal16)
- Nerd Fonts (para iconos)

### Para el widget musical
- `mpv` — reproducción de audio
- `mpv-mpris` — plugin MPRIS para mpv (expone metadata y controles)
- [CAVA](https://github.com/karlstav/cava) — visualizer de audio

### Para la barra
- `nmcli` (NetworkManager) — estado y conexión de red
- `brightnessctl` — control de brillo
- `pactl` (PipeWire/PulseAudio) — control de volumen
- `zenity` — selector de carpetas
- `hyprlock` — bloquear sesión
- `wpctl` — control de audio PipeWire

### Para el calendario
- `curl` — fetch del clima (Open-Meteo API)

### Para stats del sistema
- `sensors` (lm_sensors) — temperatura CPU/GPU
- `free` — RAM
- `df` — disco

## Atajos de teclado

| Atajo | Acción | Módulo |
|---|---|---|
| Super+Escape | Abrir/cerrar panel de control | barra |
| Super+K | Abrir/cerrar panel musical | wallclock |
| Super+D | Abrir/cerrar calendario | calendar |
| Super+L | Abrir/cerrar launcher | launcher |
| Escape | Cerrar panel activo | todos |

## Recargar después de cambios

Cada módulo tiene su script de recarga (mata el proceso y lo relanza):

```bash
~/.config/quickshell/barra/reload.sh
~/.config/quickshell/wallclock/reload.sh
~/.config/quickshell/calendar/reload.sh
~/.config/quickshell/launcher/reload.sh
```

## Archivos por módulo

### shared/
| Archivo | Descripción |
|---|---|
| `Pywal.qml` | Lee `~/.cache/wal/colors.json`, expone `color0`–`color15`, `foreground`, `background`. Watch automático. |

### barra/
| Archivo | Descripción |
|---|---|
| `shell.qml` | Panel principal, isla flotante, secciones, animaciones |
| `VolumeSection.qml` | Control de volumen con slider |
| `BrightnessSection.qml` | Control de brillo con slider |
| `NetworkSection.qml` | Estado de red, WiFi, conexión |
| `BluetoothSection.qml` | Estado y alias de bluetooth |
| `MusicWidget.qml` | Widget MPRIS con barras animadas y marquee |
| `clock.qml` | Reloj digital |
| `workspaces.qml` | Indicador de workspaces de Hyprland |
| `reload.sh` | Script de recarga |
| `hypr/barra.conf` | Autostart + layerrules + atajos |
| `hypr/lookandfeel.conf` | Blur optimizado para glassmorphism |

### wallclock/
| Archivo | Descripción |
|---|---|
| `shell.qml` | Reloj + panel musical + stats del sistema |
| `RingArc.qml` | Componente de arco para gauges |
| `cava-read.sh` | Pipe de CAVA a `/tmp/cava_bars` via FIFO |
| `find-cover.sh` | Busca carátula en la carpeta del archivo (cover.jpg, etc.) |
| `stats.sh` | Recolecta CPU/GPU temp, RAM%, DISK% |
| `reload.sh` | Script de recarga |

### calendar/
| Archivo | Descripción |
|---|---|
| `shell.qml` | Panel del calendario flotante |
| `CalendarStrip.qml` | Franja de días del mes |
| `DayItem.qml` | Item individual de día |
| `weather_fetch.sh` | Fetch del clima vía Open-Meteo API (curl) |
| `reload.sh` | Script de recarga |
| `hypr/calendar.conf` | Atajo Super+D |

### launcher/
| Archivo | Descripción |
|---|---|
| `shell.qml` | Punto de entrada del launcher |
| `LauncherPanel.qml` | Panel con búsqueda y carrusel de apps |
| `AppItem.qml` | Item visual de cada app |
| `parse-desktop.sh` | Parser de archivos `.desktop` (Python 3) |
| `reload.sh` | Script de recarga |
| `demo/` | GIF y video de demostración |

## Licencia

MIT
