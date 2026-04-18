#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
CHEZMOI_REPO="${CHEZMOI_REPO:-Axelb531/config}"
BREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

# --- Colors (macOS terminal colors) ---
if [[ -t 1 ]]; then
  RED='\033[31m'; GREEN='\033[32m'; YELLOW='\033[33m'; BLUE='\033[34m'; RESET='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; BLUE=''; RESET=''
fi

log_info()  { echo -e "${BLUE}[INFO]${RESET} $*"; }
log_ok()    { echo -e "${GREEN}[OK]${RESET} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${RESET} $*"; }
log_error() { echo -e "${RED}[ERROR]${RESET} $*" >&2; }

# --- Helpers ---

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

ensure_homebrew() {
  if command_exists brew; then
    log_ok "Homebrew already installed: $(brew --version | head -n1)"
    return 0
  fi

  log_info "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL "${BREW_INSTALL_URL}")"

  # Add to current shell if Homebrew was just installed (macOS/Linux)
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    log_warn "Homebrew installed but 'brew' not found in expected paths. Open a new shell or re-run the script."
  fi

  if command_exists brew; then
    log_ok "Homebrew installed: $(brew --version | head -n1)"
  else
    log_error "Homebrew installation finished but 'brew' command not found. Please restart your shell and re-run."
    exit 1
  fi
}

brew_install_if_missing() {
  local pkg="$1"
  if brew list --formula | grep -qx "$pkg"; then
    log_ok "$pkg already installed (brew)."
  else
    log_info "Installing $pkg via Homebrew..."
    brew install "$pkg"
    log_ok "$pkg installed."
  fi
}

ensure_chezmoi_and_gh() {
  ensure_homebrew
  brew_install_if_missing "chezmoi"
  brew_install_if_missing "gh"
}

# --- GitHub auth (private repo) ---
ensure_gh_auth() {
  # If already authenticated, skip
  if command_exists gh && gh auth status >/dev/null 2>&1; then
    log_ok "GitHub already authenticated."
    return 0
  fi

  log_info "GitHub not authenticated. Running 'gh auth login'..."
  # Interactive login (will prompt for username/password or token / 2FA / SSH, whatever you prefer)
  gh auth login
  if ! command_exists gh || [[ ! -d "$(gh auth status)" ]; then
    log_error "gh auth login failed or gh not found. Please fix manually and re-run."
    exit 1
  fi
  log_ok "GitHub authenticated."
}

apply_dotfiles() {
  log_info "Applying dotfiles with chezmoi from repo: ${CHEZMOI_REPO}"
  chezmoi init --apply "${CHEZMOI_REPO}"
  log_ok "chezmoi apply completed."
}

main() {
  log_info "Starting dotfiles setup (macOS)..."
  ensure_chezmoi_and_gh
  ensure_gh_auth
  apply_dotfiles
  log_ok "All done. Your configuration is applied."
}

main "$@"
