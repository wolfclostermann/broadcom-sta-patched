#!/usr/bin/env bash
#
# install.sh — Automated DKMS installation for broadcom-sta-patched
#
# Usage: sudo ./install.sh
#

set -euo pipefail

PACKAGE_NAME="broadcom-sta-patched"
PACKAGE_VERSION="6.30.223.271"
DEST="/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Sanity checks -----------------------------------------------------------

if [[ $EUID -ne 0 ]]; then
    echo "Error: this script must be run as root (use sudo)." >&2
    exit 1
fi

if ! command -v dkms &>/dev/null; then
    echo "Error: dkms is not installed. Install it with:" >&2
    echo "  sudo apt install dkms" >&2
    exit 1
fi

# --- Remove conflicting old modules ------------------------------------------

echo "==> Removing old broadcom-sta DKMS module (if any)..."
dkms remove broadcom-sta/6.30.223.271 --all 2>/dev/null || true

echo "==> Removing previous ${PACKAGE_NAME} DKMS module (if any)..."
dkms remove "${PACKAGE_NAME}/${PACKAGE_VERSION}" --all 2>/dev/null || true

# --- Copy source to /usr/src --------------------------------------------------

echo "==> Copying source to ${DEST}..."
rm -rf "${DEST}"
mkdir -p "${DEST}"
# Copy only the files needed for building (skip build artifacts)
cp -r "${SCRIPT_DIR}/src" "${DEST}/"
cp -r "${SCRIPT_DIR}/lib" "${DEST}/"
cp    "${SCRIPT_DIR}/Makefile" "${DEST}/"
cp    "${SCRIPT_DIR}/dkms.conf" "${DEST}/"

# --- DKMS add / build / install -----------------------------------------------

echo "==> dkms add ${PACKAGE_NAME}/${PACKAGE_VERSION}..."
dkms add "${PACKAGE_NAME}/${PACKAGE_VERSION}"

echo "==> dkms build ${PACKAGE_NAME}/${PACKAGE_VERSION}..."
dkms build "${PACKAGE_NAME}/${PACKAGE_VERSION}"

echo "==> dkms install ${PACKAGE_NAME}/${PACKAGE_VERSION}..."
dkms install "${PACKAGE_NAME}/${PACKAGE_VERSION}"

# --- Load the module ----------------------------------------------------------

echo "==> Loading wl module..."
modprobe -r wl 2>/dev/null || true
modprobe wl

echo ""
echo "Done! The wl module is loaded. Verify with:"
echo "  lsmod | grep wl"
echo "  dkms status"
