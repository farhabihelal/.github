#!/usr/bin/env bash
# =============================================================================
# system-update.sh
# Description : Update and upgrade system packages on Debian/Ubuntu systems,
#               optionally removing orphaned packages and cleaning apt cache.
# Usage       : bash system-update.sh [--clean] [--reboot]
# Author      : Farhabi Helal <https://github.com/farhabihelal>
# =============================================================================

set -euo pipefail

# ---- Colours ----------------------------------------------------------------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

log_info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
log_success() { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

die() { log_error "$*"; exit 1; }

# ---- Argument Parsing -------------------------------------------------------
CLEAN=false
DO_REBOOT=false

for arg in "$@"; do
    case "$arg" in
        --clean)  CLEAN=true ;;
        --reboot) DO_REBOOT=true ;;
        -h|--help)
            echo "Usage: $0 [--clean] [--reboot]"
            echo "  --clean   Remove orphaned packages and clear apt cache"
            echo "  --reboot  Reboot after update if a kernel upgrade was installed"
            exit 0
            ;;
        *) log_warn "Unknown argument: $arg" ;;
    esac
done

# ---- Root Check -------------------------------------------------------------
[[ "$EUID" -eq 0 ]] || die "Run as root or with sudo."

# ---- Update -----------------------------------------------------------------
log_info "Updating package lists..."
apt-get update -qq
log_success "Package lists updated."

log_info "Upgrading installed packages..."
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
log_success "Packages upgraded."

log_info "Running dist-upgrade..."
DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
log_success "Dist-upgrade complete."

# ---- Optional Clean ---------------------------------------------------------
if [[ "$CLEAN" == true ]]; then
    log_info "Removing orphaned packages..."
    apt-get autoremove -y
    log_info "Cleaning apt cache..."
    apt-get autoclean -y
    log_success "System cleaned."
fi

# ---- Reboot Check -----------------------------------------------------------
if [[ "$DO_REBOOT" == true ]] && [[ -f /var/run/reboot-required ]]; then
    log_warn "Kernel update detected. Rebooting in 10 seconds... (Ctrl+C to cancel)"
    sleep 10
    reboot
elif [[ -f /var/run/reboot-required ]]; then
    log_warn "A reboot is required to apply kernel updates. Run with --reboot or reboot manually."
fi

log_success "System update complete! ✅"
