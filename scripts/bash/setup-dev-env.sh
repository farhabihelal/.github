#!/usr/bin/env bash
# =============================================================================
# setup-dev-env.sh
# Description : Bootstrap a development environment on a fresh Debian/Ubuntu
#               system. Installs common development tools, Python, Node.js,
#               Docker, and configures shell defaults.
# Usage       : bash setup-dev-env.sh [--dry-run]
# Author      : Farhabi Helal <https://github.com/farhabihelal>
# =============================================================================

set -euo pipefail

# ---- Colours ----------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Colour

# ---- Helpers ----------------------------------------------------------------
log_info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
log_success() { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

die() { log_error "$*"; exit 1; }

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

run() {
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} $*"
    else
        eval "$@"
    fi
}

require_root() {
    [[ "$EUID" -eq 0 ]] || die "This script must be run as root (or with sudo)."
}

# ---- OS Detection -----------------------------------------------------------
detect_os() {
    if [[ -f /etc/os-release ]]; then
        # shellcheck source=/dev/null
        source /etc/os-release
        OS="${ID}"
        OS_VERSION="${VERSION_ID:-unknown}"
    else
        die "Cannot detect OS. /etc/os-release not found."
    fi
    log_info "Detected OS: ${OS} ${OS_VERSION}"
}

# ---- Package Installation ---------------------------------------------------
install_base_packages() {
    log_info "Installing base packages..."
    run apt-get update -qq
    run apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        wget \
        git \
        vim \
        tmux \
        htop \
        unzip \
        jq \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common
    log_success "Base packages installed."
}

install_python() {
    log_info "Installing Python 3 and pip..."
    run apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev
    run pip3 install --upgrade pip setuptools wheel
    log_success "Python installed: $(python3 --version 2>&1)"
}

install_nodejs() {
    local node_version="${NODE_VERSION:-20}"
    log_info "Installing Node.js ${node_version}.x..."
    # NOTE: Piping curl to bash is a convenience pattern but carries a risk if
    # the download is intercepted. For production use, verify the script's
    # checksum or use a package manager (e.g., nvm) with integrity verification.
    run curl -fsSL "https://deb.nodesource.com/setup_${node_version}.x" | bash -
    run apt-get install -y nodejs
    log_success "Node.js installed: $(node --version 2>&1), npm: $(npm --version 2>&1)"
}

install_docker() {
    log_info "Installing Docker..."
    if command -v docker &>/dev/null; then
        log_warn "Docker is already installed: $(docker --version). Skipping."
        return
    fi
    run curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    run echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
        https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
        | tee /etc/apt/sources.list.d/docker.list > /dev/null
    run apt-get update -qq
    run apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    run usermod -aG docker "${SUDO_USER:-$USER}" || true
    log_success "Docker installed: $(docker --version 2>&1)"
}

# ---- Shell Setup ------------------------------------------------------------
setup_git() {
    log_info "Configuring git defaults..."
    run git config --global init.defaultBranch main
    run git config --global core.editor vim
    run git config --global pull.rebase false
    log_success "Git configured."
}

# ---- Main -------------------------------------------------------------------
main() {
    log_info "Starting development environment setup..."
    [[ "$DRY_RUN" == true ]] && log_warn "Dry-run mode: no changes will be made."

    require_root
    detect_os

    [[ "${OS}" == "ubuntu" || "${OS}" == "debian" ]] \
        || die "Unsupported OS '${OS}'. This script supports Ubuntu/Debian only."

    install_base_packages
    install_python
    install_nodejs
    install_docker
    setup_git

    log_success "Development environment setup complete! 🎉"
    log_info "Please log out and back in for group changes (docker) to take effect."
}

main "$@"
