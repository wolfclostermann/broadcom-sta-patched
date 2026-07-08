# Broadcom STA (wl) Driver 6.30.223.271 — Patched for Linux 6.17+

Patched version of the Broadcom STA (`wl`) wireless driver, updated to compile on modern Linux kernels (6.8 through 6.17+). Based on the original `broadcom-sta` package from Ubuntu/Debian repositories.

## Supported Hardware

- **BCM4360** (PCI ID `14e4:43a0`) and all other Broadcom cards supported by the original `broadcom-sta` / `wl` driver.
- Check with: `lspci -nn | grep -i broadcom`

## Patches Applied

The following changes were made on top of the stock `broadcom-sta 6.30.223.271` source:

| # | File(s) | Description |
|---|---------|-------------|
| 1 | `Makefile` | Replace `EXTRA_CFLAGS` / `EXTRA_LDFLAGS` with `ccflags-y` / `ldflags-y` (removed upstream in kernel 6.17). |
| 2 | `src/wl/sys/wl_linux.c`, `src/include/wl_linux.h` | `ndo_do_ioctl` -> `ndo_siocdevprivate` (guarded `>= 5.15`). |
| 3 | `src/include/linuxver.h` | `smp_read_barrier_depends()` -> no-op (guarded `>= 5.9`). |
| 4 | `src/include/linuxver.h` | `FN_ISR` typedef: removed `pt_regs` parameter (guarded `>= 2.6.19`). |
| 5 | `src/wl/sys/wl_linux.c` | `from_timer()` -> `timer_container_of()` (guarded `>= 6.16`). |
| 6 | `src/wl/sys/wl_linux.c` | `del_timer()` -> `timer_delete()` (guarded `>= 6.16`). |
| 7 | `src/wl/sys/wl_cfg80211_hybrid.c` | cfg80211 API signature changes for 6.16+: `set_wiphy_params`, `set_tx_power`, `get_tx_power`. |
| 8 | `src/wl/sys/wl_cfg80211_hybrid.c` | Added `fallthrough` keyword for switch-case fall-throughs. |
| 9 | `src/include/linuxver.h` | Added `#include <linux/timer.h>`. |

## Installation (DKMS)

### Quick install

```bash
sudo ./install.sh
```

### Manual steps

```bash
# 1. Remove the stock broadcom-sta DKMS module if present
sudo dkms remove broadcom-sta/6.30.223.271 --all 2>/dev/null

# 2. Copy this source tree to /usr/src
sudo cp -r . /usr/src/broadcom-sta-patched-6.30.223.271

# 3. Register, build, and install via DKMS
sudo dkms add broadcom-sta-patched/6.30.223.271
sudo dkms build broadcom-sta-patched/6.30.223.271
sudo dkms install broadcom-sta-patched/6.30.223.271

# 4. Load the module
sudo modprobe wl
```

## Troubleshooting

```bash
# Check if the module is loaded
lsmod | grep wl

# Try loading it manually
sudo modprobe wl

# Check kernel log for errors
dmesg | grep -i "wl\|broadcom\|brcm\|error" | tail -30

# Check DKMS status
dkms status

# Rebuild manually if needed
cd /usr/src/broadcom-sta-patched-6.30.223.271
sudo make KVER=$(uname -r) clean
sudo make KVER=$(uname -r)
```

To boot into a previous kernel: restart and select **Advanced options** in GRUB, then pick your working kernel.

## Tested On

- Ubuntu 24.04 LTS, kernel `6.8.0-40-generic`
- Ubuntu 24.04 LTS, kernel `6.17.0-14-generic`

## License

Mixed / Proprietary. Same license as the original Broadcom STA driver. The precompiled object files in `lib/` are Broadcom proprietary blobs; the open-source shim layer is subject to its original license terms.

---

# Broadcom STA (wl) Driver 6.30.223.271 — Parcheado para Linux 6.17+

Version parcheada del driver inalambrico Broadcom STA (`wl`), actualizado para compilar en kernels modernos de Linux (6.8 a 6.17+). Basado en el paquete original `broadcom-sta` de los repositorios de Ubuntu/Debian.

## Hardware Soportado

- **BCM4360** (PCI ID `14e4:43a0`) y todas las demas tarjetas Broadcom soportadas por el driver original `broadcom-sta` / `wl`.
- Verificar con: `lspci -nn | grep -i broadcom`

## Parches Aplicados

Los siguientes cambios se realizaron sobre el codigo fuente original de `broadcom-sta 6.30.223.271`:

| # | Archivo(s) | Descripcion |
|---|------------|-------------|
| 1 | `Makefile` | Reemplazar `EXTRA_CFLAGS` / `EXTRA_LDFLAGS` por `ccflags-y` / `ldflags-y` (eliminados en kernel 6.17). |
| 2 | `src/wl/sys/wl_linux.c`, `src/include/wl_linux.h` | `ndo_do_ioctl` -> `ndo_siocdevprivate` (protegido `>= 5.15`). |
| 3 | `src/include/linuxver.h` | `smp_read_barrier_depends()` -> no-op (protegido `>= 5.9`). |
| 4 | `src/include/linuxver.h` | Typedef `FN_ISR`: eliminado parametro `pt_regs` (protegido `>= 2.6.19`). |
| 5 | `src/wl/sys/wl_linux.c` | `from_timer()` -> `timer_container_of()` (protegido `>= 6.16`). |
| 6 | `src/wl/sys/wl_linux.c` | `del_timer()` -> `timer_delete()` (protegido `>= 6.16`). |
| 7 | `src/wl/sys/wl_cfg80211_hybrid.c` | Cambios en firmas de la API cfg80211 para 6.16+: `set_wiphy_params`, `set_tx_power`, `get_tx_power`. |
| 8 | `src/wl/sys/wl_cfg80211_hybrid.c` | Agregada palabra clave `fallthrough` para casos switch-case. |
| 9 | `src/include/linuxver.h` | Agregado `#include <linux/timer.h>`. |

## Instalacion (DKMS)

### Instalacion rapida

```bash
sudo ./install.sh
```

### Pasos manuales

```bash
# 1. Eliminar el modulo DKMS de broadcom-sta original si existe
sudo dkms remove broadcom-sta/6.30.223.271 --all 2>/dev/null

# 2. Copiar este arbol de fuentes a /usr/src
sudo cp -r . /usr/src/broadcom-sta-patched-6.30.223.271

# 3. Registrar, compilar e instalar via DKMS
sudo dkms add broadcom-sta-patched/6.30.223.271
sudo dkms build broadcom-sta-patched/6.30.223.271
sudo dkms install broadcom-sta-patched/6.30.223.271

# 4. Cargar el modulo
sudo modprobe wl
```

## Solucion de Problemas

```bash
# Verificar si el modulo esta cargado
lsmod | grep wl

# Intentar cargarlo manualmente
sudo modprobe wl

# Ver errores en el log del kernel
dmesg | grep -i "wl\|broadcom\|brcm\|error" | tail -30

# Ver estado de DKMS
dkms status

# Recompilar manualmente si es necesario
cd /usr/src/broadcom-sta-patched-6.30.223.271
sudo make KVER=$(uname -r) clean
sudo make KVER=$(uname -r)
```

Para arrancar con un kernel anterior: reinicia y selecciona **Advanced options** en GRUB, luego elige tu kernel funcional.

## Probado En

- Ubuntu 24.04 LTS, kernel `6.8.0-40-generic`
- Ubuntu 24.04 LTS, kernel `6.17.0-14-generic`

## Licencia

Mixta / Propietaria. Misma licencia que el driver original Broadcom STA. Los archivos objeto precompilados en `lib/` son blobs propietarios de Broadcom; la capa shim de codigo abierto esta sujeta a los terminos de su licencia original.
