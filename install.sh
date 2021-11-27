#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Local vars
HOME_ZPROFILE="$HOME/.zprofile"
HOME_ZSHRC="$HOME/.zshrc"
UNAME_MACHINE="$(/usr/bin/uname -m)"

# Install Xcode Command-Line Tools
/bin/bash -c "$(xcode-select --install)"

# Install Rosetta 2 if using Apple Silicon
if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
    echo "[Apple Silicon] Installing Rosetta 2..."
    softwareupdate --install-rosetta
fi

# Find the CLI Tools update
echo "Checking for CLI Tool updates..."
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n') || true
# Install CLIE Tools update
if [[ ! -z "$PROD" ]]; then
  softwareupdate -i "$PROD" --verbose
fi

# Check for Homebrew, install if not installed
if test ! $(which brew); then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # load shellenv for Apple Silicon
  if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
    echo "Added Homebrew shell to ${HOME_ZPROFILE}."
    echo '# Add Homebrew support' >> ${HOME_ZPROFILE}
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ${HOME_ZPROFILE}
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# List of packages
PACKAGES=(
  # GNU Core Utilities
  coreutils
  findutils
  grep
  gnu-sed
  gnu-tar
  gnu-indent
  gnu-which
  gawk
  wget
  # Git & GitHub CLI
  git
  gh
  jq
  tree
  zsh
)

echo "Installing brew packages..."
brew install ${PACKAGES[@]}

# git default config / ignore
if [[ ! -f "${HOME}/.gitconfig" ]]; then
    echo "Installing .gitconfig..."
    cp ./utils/git/.gitconfig ~/.gitconfig
fi
if [[ ! -f "${HOME}/.gitignore" ]]; then
    echo "Installing .gitignore..."
    cp ./utils/git/.gitignore ~/.gitignore
fi

# Install Oh My Zsh
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k theme for Oh My Zsh
if [[ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]]; then
  echo "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  sed -i -e 's/ZSH_THEME="\(.*\)"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ${HOME_ZSHRC}
fi

# Install [nvm, NodeJS, yarn]
if ! grep -q "NVM" ${HOME_ZSHRC}; then
    # Install nvm
    echo "Installing nvm..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh)"

    # Install latest LTS version of NodeJS
    echo "Installing NodeJS (LTS)..."
    /bin/bash -c "$(nvm install --lts)"

    # Install yarni
    echo "Installing yarn..."
    /bin/bash -c "$(npm -g upgrade yarn)"
fi

# Install Rust
if [[ ! -d $HOME/.cargo ]]; then
    echo "Installing Rust..."
    /bin/bash -c "$(curl -fsS https://sh.rustup.rs | sh -s -- -y)"
fi

# Initialize GNU overrides
if ! grep -q "GNU" ${HOME_ZSHRC}; then
  echo "Added GNU shell overrides to ${HOME_ZSHRC}"
  echo '' >> ${HOME_ZSHRC}
  echo '# GNU shell overrides' >> ${HOME_ZSHRC}
  echo 'PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="/opt/homebrew/opt/gnu-indent/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
  echo 'PATH="/opt/homebrew/opt/gnu-which/libexec/gnubin:$PATH"' >> ${HOME_ZSHRC}
fi