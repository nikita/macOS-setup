# macOS-setup

Automation to setup new MacBook for software development (supports Apple Silicon).

# Installs

- Xcode Command-Line Tools (Checks for updates too)
- Rosetta 2 (Apple Silicon)
- Homebrew (GNU Core Utilities, git, wget, zsh, etc)
- Oh My Zsh
- Powerlevel10k theme for Oh My Zsh
- nvm (NodeJS, Yarn)
- Rust

# Configs

- git (Default .gitconfig / .gitignore)

## Installation

```sh
chmod +x ./install.sh && ./install.sh
```

## Inspired By

- https://github.com/marcusguttenplan/creative-tech-toolkit/blob/master/bootstrappers/mac/bootstrapper.sh
- https://medium.com/macoclock/automating-your-macos-setup-with-homebrew-and-cask-e2a103b51af1
- https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/
