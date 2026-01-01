# Nix Home Configuration

Reproducible development environment configuration using [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager).

This configuration provides a declarative, cross-platform setup for development tools (neovim, tmux, zsh) that works on both Linux and macOS.

## Features

### Home Environment
- **Reproducible**: Same configuration across all machines
- **Cross-platform**: Works on Linux (x86_64) and macOS (Apple Silicon)
- **Instant updates**: Edit config files and changes apply immediately (no rebuild needed)
- **Version controlled**: All configurations managed in git
- **Declarative**: Tools installed and configured via Nix flake

### Project Environments (NEW!)
- **Per-project isolation**: Each project can have different language versions
- **Auto-switching**: Environments load automatically when entering directories (direnv)
- **LSP integration**: Language servers use project-specific dependencies
- **Hybrid development**: Edit on host (with LSP), build in containers

## Structure

### Home Environment
```
~/nix-home/
├── flake.nix               # Main Nix configuration
├── flake.lock              # Dependency lock file
├── common.nix              # Shared configuration (all platforms)
├── mac.nix                 # macOS-specific packages
├── home-dev.nix            # Linux-specific packages
├── starship.toml           # Starship prompt configuration
├── README.md               # This file
├── CHEATSHEET.md          # Quick reference for keybindings
├── nvim/                   # Neovim configuration
│   ├── init.lua           # Main neovim config
│   └── lua/plugins/
│       ├── ui.lua         # Themes, statusline
│       ├── editor.lua     # File explorer, which-key
│       ├── coding.lua     # AI completion, treesitter
│       ├── lsp.lua        # LSP configuration
│       ├── markdown.lua   # Markdown preview
│       └── git.lua        # Git integration (NEW!)
├── tmux/                   # Tmux configuration
│   └── tmux.conf          # OSC 52 clipboard support
├── wezterm/                # Wezterm configuration (macOS)
│   └── wezterm.lua        # Terminal with SSH clipboard
└── zsh/                    # Zsh configuration
    └── .zshrc
```

### Project Environment Example
```
~/work/my-python-project/
├── flake.nix              # Project-specific Nix environment
├── .envrc                 # direnv configuration ("use flake")
├── src/
│   └── main.py
└── tests/
```

## Quick Start

### Prerequisites

- [Nix](https://nixos.org/download.html) installed with flakes enabled
- Git

### Installation

1. **Clone this repository:**
   ```bash
   git clone <your-repo-url> ~/nix-home
   cd ~/nix-home
   ```

2. **Apply the configuration:**

   For Linux (Ubuntu):
   ```bash
   nix run home-manager/master -- switch --flake .#home-dev --impure
   ```

   For macOS (Apple Silicon):
   ```bash
   nix run home-manager/master -- switch --flake .#mac --impure
   ```

   **Note**: The `--impure` flag is required because the configuration uses environment variables (`$USER`, `$HOME`) for flexibility across machines.

3. **Set zsh as default shell (optional):**
   ```bash
   ./bootstrap.sh
   ```

That's it! All configurations are now symlinked and ready to use.

## How It Works

### Direct Symlinks (Not Nix Store)

Unlike traditional Nix configurations that copy files to the nix store (making them read-only), this setup creates direct symlinks:

- `~/.config/nvim/` → `~/nix-home/nvim/`
- `~/.config/tmux/tmux.conf` → `~/nix-home/tmux/tmux.conf`
- `~/.zshrc` sources `~/nix-home/zsh/.zshrc`

**Benefits:**
- Edit files directly in `~/nix-home/` and see changes immediately
- No need to run `home-manager switch` after config changes
- Still get reproducibility benefits from Nix (packages, versions)

### What Nix Manages

- **Package installation**: neovim, tmux, zsh, git, ripgrep, fd, fzf, etc.
- **Symlink creation**: Automatically links config files on new systems
- **Cross-platform differences**: Platform-specific packages (e.g., pinentry)

### What You Manage

- **Configuration files**: Edit directly in `~/nix-home/`
- **Plugin management**: Neovim uses lazy.nvim for plugin management

## Usage

### Updating Configurations

Simply edit files in `~/nix-home/` and changes take effect immediately:

```bash
# Edit neovim config
vim ~/nix-home/nvim/init.lua

# Edit tmux config
vim ~/nix-home/tmux/tmux.conf

# Edit zsh config
vim ~/nix-home/zsh/.zshrc
```

No rebuild needed! Just reload the application (e.g., `:source $MYVIMRC` in neovim, `tmux source-file ~/.config/tmux/tmux.conf` in tmux).

### Adding/Removing Packages

To add or remove system packages, edit `flake.nix`:

```nix
home.packages = with pkgs; [
  git
  ripgrep
  # Add more packages here
];
```

Then apply changes:
```bash
nix run home-manager/master -- switch --flake .#home-dev  # or .#mac
```

### Updating Dependencies

Update flake inputs (nixpkgs, home-manager):

```bash
nix flake update
nix run home-manager/master -- switch --flake .#home-dev
```

## Profiles

This configuration supports multiple profiles:

- `home-dev`: Linux (x86_64) for user "dev-user"
- `mac`: macOS (aarch64) for user "satoshi"

Edit `flake.nix` to add your own profiles or modify existing ones.

## Installed Tools

### Core Tools
- **neovim**: Text editor with lazy.nvim plugin manager and LSP
- **tmux**: Terminal multiplexer with vim-style navigation and SSH clipboard support (OSC 52)
- **zsh**: Shell with Starship prompt, autosuggestions, and syntax highlighting
- **wezterm** (macOS): Modern GPU-accelerated terminal with OSC 52 clipboard integration

### Development Tools
- **git**: Version control
- **gh**: GitHub CLI
- **lazygit**: Terminal UI for Git operations
- **nodejs**: JavaScript runtime (required for markdown-preview.nvim)
- **ripgrep (rg)**: Fast grep alternative
- **fd**: Fast find alternative
- **fzf**: Fuzzy finder for history and file search
- **direnv**: Automatic environment switching per directory
- **nix-direnv**: Improved direnv integration with Nix
- **starship**: Cross-shell prompt with Git and language version indicators
- **htop**: Interactive process viewer
- **xclip** (Linux): X11 clipboard tool

### Container Tools
- **podman**: Container runtime

### Neovim Plugins

**Editor:**
- **kanagawa.nvim**: Colorscheme
- **lualine.nvim**: Statusline
- **oil.nvim**: File explorer (edit directories like text)
- **which-key.nvim**: Keybinding help
- **nvim-treesitter**: Syntax highlighting

**Coding:**
- **nvim-lspconfig**: LSP client (Python, Rust, C++ support)
- **nvim-cmp**: Auto-completion engine
- **Codeium**: AI code completion
- **markdown-preview.nvim**: Live markdown preview

**Git Integration:**
- **gitsigns.nvim**: Git signs in gutter, blame, hunk operations
- **neogit**: Magit-like Git interface for Neovim
- **diffview.nvim**: Enhanced diff and file history viewer
- **vim-fugitive**: Classic Git commands

## Git Workflow

### lazygit (Terminal UI)

The fastest way to interact with Git:

```bash
# In any git repository
lg  # or lazygit

# Main operations
Space    # Stage/unstage file
c        # Commit
P        # Push
p        # Pull
[/]      # Previous/next tab
?        # Help
q        # Quit
```

**Workflow:**
1. `lg` to open lazygit
2. Navigate with arrows/hjkl
3. `Space` to stage files
4. `c` to commit
5. `P` to push

### Neovim Git Integration

**gitsigns** shows changes in the gutter:
- `]c` / `[c`: Jump to next/previous change
- `<leader>hp`: Preview hunk
- `<leader>hb`: Git blame for line
- `<leader>hs`: Stage hunk
- `<leader>hr`: Reset hunk

**Neogit** for full Git operations in Neovim:
- `<leader>gg`: Open Neogit
- `<leader>gc`: Git commit
- `<leader>gp`: Git push

**Diffview** for reviewing changes:
- `<leader>gd`: Open diff view
- `<leader>gh`: File history
- `<leader>gH`: Repository history

See CHEATSHEET.md for complete keybindings.

## SSH Clipboard Integration

Copy text from remote tmux sessions to your local clipboard using **OSC 52**.

### How It Works

1. **tmux** sends clipboard data via escape sequences
2. **Wezterm** (macOS) or compatible terminal receives it
3. Text appears in your local system clipboard

### Setup (macOS with Wezterm)

**Already configured!** Just use tmux copy mode:

```bash
# SSH into Linux machine
ssh user@remote

# In tmux
Ctrl+b [          # Enter copy mode
v                 # Start selection (vim-style)
hjkl or arrows    # Navigate
y                 # Copy to clipboard
```

**Paste on macOS:**
- Any application: `Cmd+V`
- Terminal: `Cmd+V`

### Terminal Requirements

**Wezterm** (recommended, macOS):
- Pre-configured in `~/nix-home/wezterm/wezterm.lua`
- OSC 52 enabled by default

**Other terminals:**
- **iTerm2**: Enable in Settings → General → Selection → "Applications in terminal may access clipboard"
- **VS Code**: Supported by default
- **Alacritty**: Add `save_to_clipboard: true` in config

## Platform-Specific Configuration

This configuration uses a modular approach for platform-specific packages:

### Common Packages (`common.nix`)
Packages available on all platforms:
- git, gh, lazygit
- neovim, tmux
- ripgrep, fd, fzf
- direnv, starship
- podman, htop

### macOS-Specific (`mac.nix`)
- wezterm (terminal)
- pinentry_mac (GPG)

### Linux-Specific (`home-dev.nix`)
- xclip (clipboard)
- pinentry-curses (GPG)

### Adding Packages

**For all platforms:** Edit `common.nix`
```nix
home.packages = with pkgs; [
  git
  # Add your package here
];
```

**For macOS only:** Edit `mac.nix`
**For Linux only:** Edit `home-dev.nix`

Then apply:
```bash
# Linux
hms

# macOS
gms
```

## Customization

### Neovim

Plugins are managed via [lazy.nvim](https://github.com/folke/lazy.nvim):
- Edit `~/nix-home/nvim/lua/plugins.lua` to add/remove plugins
- Plugins are automatically installed on first launch

Current plugins:
- kanagawa.nvim (colorscheme)
- lualine.nvim (statusline)
- markdown-preview.nvim (live markdown preview)

#### Markdown Preview (SSH Remote)

When accessing via SSH, use port forwarding to preview markdown files in your local browser:

**1. Connect with port forwarding:**
```bash
ssh -L 8080:localhost:8080 home-dev
```

Or add to `~/.ssh/config` on your local machine:
```
Host home-dev
    LocalForward 8080 localhost:8080
```

**2. Open markdown file in neovim:**
```bash
nvim README.md
```

**3. Start preview:**
- Press `<leader>mp` (space + mp) or run `:MarkdownPreview`
- Open `http://localhost:8080` in your local browser
- Edit the file and see live updates!

**4. Stop preview:**
- Press `<leader>ms` (space + ms) or run `:MarkdownPreviewStop`

### Tmux

Configuration includes:
- Mouse support enabled
- Vim-style key bindings
- Custom status bar
- Intuitive pane splitting (`|` and `-`)

### Zsh

Configuration includes:
- **Starship prompt**: Rich prompt with Git, time, and language version indicators
- **zsh-autosuggestions**: Fish-like autosuggestions from history
- **zsh-syntax-highlighting**: Command validation with color coding
- **fzf integration**: Ctrl+r for history search, Ctrl+t for file search
- **Custom aliases**: Git shortcuts, Nix helpers, navigation shortcuts
- **direnv integration**: Automatic project environment loading

## Project-Specific Environments

### Overview

Each project can have its own isolated environment with specific language versions and dependencies. This is achieved using **direnv** + **nix flakes**.

### How It Works

1. **Create project-specific `flake.nix`** defining packages and dependencies
2. **Add `.envrc`** with `use flake` to enable direnv
3. **Auto-load on `cd`**: Environment activates when entering the directory
4. **LSP integration**: nvim LSP automatically uses project dependencies

### Example: Python Project

**1. Create project structure:**
```bash
mkdir ~/work/ml-project
cd ~/work/ml-project
```

**2. Create `flake.nix`:**
```nix
{
  description = "Machine Learning Project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }: {
    devShells.x86_64-linux.default = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in pkgs.mkShell {
      packages = with pkgs; [
        python311
        python311Packages.numpy
        python311Packages.pandas
        python311Packages.scikit-learn
        python311Packages.python-lsp-server
      ];

      shellHook = ''
        echo "🐍 ML Project environment loaded"
        python --version
      '';
    };
  };
}
```

**3. Create `.envrc`:**
```bash
echo "use flake" > .envrc
direnv allow
```

**4. Test:**
```bash
cd ~/work/ml-project
# Automatically loads: Python 3.11 + numpy + pandas + scikit-learn
# Prompt shows: via ❄️ impure via 🐍 v3.11.14

python -c "import numpy; print(numpy.__version__)"  # Works!

cd ~
# Environment automatically unloads
python -c "import numpy"  # Error (not in project environment)
```

### Example: Rust Project

```nix
{
  description = "Rust Project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }: {
    devShells.x86_64-linux.default = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in pkgs.mkShell {
      packages = with pkgs; [
        rustc
        cargo
        rust-analyzer
        clippy
        rustfmt
      ];
    };
  };
}
```

### Hybrid Development Workflow

**Recommended approach: Edit on host + Build in container**

```bash
# Host side (with LSP)
cd ~/work/myproject
nvim src/main.py
# → Full LSP support, instant feedback

# Container side (isolated build)
podman run -v ./:/app python:3.11 python /app/src/main.py
```

**Benefits:**
- **Host**: Fast LSP responses, accurate completion
- **Container**: Reproducible builds, isolated dependencies
- **No conflict**: Host dependencies for LSP, container for execution

## LSP Configuration

nvim is configured with LSP support for multiple languages:

### Python (pylsp)
- Automatic completion for installed packages
- Go to definition, find references
- Hover documentation
- Requires `python3XXPackages.python-lsp-server` in project's flake.nix

### Rust (rust-analyzer)
- Cargo integration
- Inline type hints
- Code actions and refactoring
- Requires `rust-analyzer` in project's flake.nix

### C++ (clangd)
- clang-tidy integration
- Compile commands support
- Header navigation
- Requires `clangd` in project's flake.nix

### Keybindings

See CHEATSHEET.md for full list. Common ones:
- `gd`: Go to definition
- `K`: Show documentation
- `<leader>rn`: Rename symbol
- `]d` / `[d`: Next/previous diagnostic

## Troubleshooting

### Symlinks not created

If symlinks aren't created automatically, manually run:
```bash
nix run home-manager/master -- switch --flake .#home-dev --show-trace
```

### Configuration not loading

Verify symlinks:
```bash
ls -la ~/.config/nvim
ls -la ~/.config/tmux/tmux.conf
grep "nix-home" ~/.zshrc
```

### Nix flakes not enabled

Enable flakes in `~/.config/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

### direnv not loading environment

**Check if direnv is running:**
```bash
direnv status
```

**Common fixes:**
```bash
# 1. Allow the directory (required first time)
direnv allow

# 2. Reload manually
direnv reload

# 3. Check .envrc exists
cat .envrc  # Should show "use flake"

# 4. Verify direnv hook is in .zshrc
grep "direnv hook" ~/.zshrc
```

### LSP not working in project

**Checklist:**
1. Is LSP server in project's `flake.nix`?
   - Python needs `python311Packages.python-lsp-server`
   - Rust needs `rust-analyzer`
   - C++ needs `clangd`

2. Is direnv environment loaded?
   - Check prompt shows `via ❄️ impure`

3. Check LSP status:
   ```vim
   :LspInfo
   ```

4. Restart nvim in the project directory

## Contributing

Feel free to customize this configuration for your own use. Fork and modify as needed!

## License

MIT
