# Nix-Home Cheat Sheet

Quick reference for tmux, neovim, and development workflow.

---

## 📺 Tmux

### Session Management
```bash
tmux new -s <name>           # Start new session
tmux attach -t <name>        # Attach to session
tmux ls                      # List sessions
Ctrl+b d                     # Detach from session
```

### Pane Management
```
Ctrl+b |                     # Split vertically
Ctrl+b -                     # Split horizontally
Ctrl+b h/j/k/l              # Navigate panes (vim-style)
Ctrl+b z                     # Toggle pane zoom
Ctrl+b x                     # Close current pane
```

### Pane Resizing
```
Ctrl+b H/J/K/L              # Resize pane (hold and repeat)
```

### Window Management
```
Ctrl+b c                     # Create new window
Ctrl+b n                     # Next window
Ctrl+b p                     # Previous window
Ctrl+b Tab                   # Last window
Ctrl+b <number>             # Go to window number
Ctrl+b ,                     # Rename window
```

### Copy Mode
```
Ctrl+b [                     # Enter copy mode
Space                        # Start selection
Enter                        # Copy selection
Ctrl+b ]                     # Paste
q                            # Quit copy mode
```

### Misc
```
Ctrl+b r                     # Reload tmux config
Ctrl+b ?                     # Show all keybindings
```

---

## 🐚 Zsh

### Starship Prompt

**Prompt Layout:**
```
╭─at 12:34:56 user@hostname in ~/nix-home on  main [📝1 🤷2]
╰─via 🐍 3.11.0 ⏱️ 2s ❯
```

**Indicators:**
- `📝` Modified files
- `✅` Staged files
- `🤷` Untracked files
- `📦` Stashed changes
- `🗑️` Deleted files
- `⏱️` Command duration (if >= 500ms)
- `❯` Green = success, Red = error

### Auto-suggestions

```bash
git st█atus              # Type "git st" → suggestion appears in gray
→                        # Right arrow: Accept full suggestion
Ctrl+→                   # Accept suggestion word by word
Esc                      # Ignore suggestion
```

### Syntax Highlighting

- **Green** = Valid command
- **Red** = Invalid command/typo
- **Underlined** = Existing file/directory

### fzf (Fuzzy Finder)

```bash
Ctrl+r                   # Search command history (fuzzy)
Ctrl+t                   # Search files in current directory
cd **[Tab]               # Fuzzy search directories
```

**In fzf interface:**
```
Type to filter
↑/↓ or Ctrl+j/k         # Navigate results
Enter                    # Select
Esc                      # Cancel
```

### History Navigation

```bash
Ctrl+p                   # Previous command (same as ↑)
Ctrl+n                   # Next command (same as ↓)
Ctrl+r                   # Search history with fzf
```

### Useful Aliases

**Basic:**
```bash
v                        # nvim
c                        # clear
h                        # history
reload                   # Restart zsh
..                       # cd ..
...                      # cd ../..
```

**Git:**
```bash
gs                       # git status
gd                       # git diff
ga                       # git add
gc                       # git commit
gco                      # git checkout
gp                       # git push
gl                       # git pull
glog                     # git log --oneline --graph --decorate
gst                      # git stash
```

**Nix/Home-Manager:**
```bash
hms                      # Home Manager switch (cd ~/nix-home && apply)
hme                      # Open nix-home in nvim
```

**Safety (with confirmation):**
```bash
rm                       # rm -i (confirm before delete)
cp                       # cp -i (confirm before overwrite)
mv                       # mv -i (confirm before overwrite)
```

**Utilities:**
```bash
path                     # Display PATH nicely
ports                    # Show port usage (netstat)
```

---

## ✏️ Neovim

### Basic Navigation (Normal Mode)
```
h/j/k/l                      # Left/Down/Up/Right
w                            # Next word
b                            # Previous word
0                            # Start of line
$                            # End of line
gg                           # First line
G                            # Last line
Ctrl+u / Ctrl+d             # Half page up/down
```

### Modes
```
i                            # Insert mode (before cursor)
a                            # Insert mode (after cursor)
I                            # Insert at start of line
A                            # Insert at end of line
v                            # Visual mode
V                            # Visual line mode
Esc or Ctrl+[               # Return to Normal mode
```

### File Operations
```
Space + w                    # Save file
Space + q                    # Quit
:w <filename>               # Save as
:wq or :x                   # Save and quit
:q!                         # Quit without saving
:e <file>                   # Open file
:bn / :bp                   # Next/previous buffer
```

### Editing
```
dd                           # Delete line
yy                           # Yank (copy) line
p                            # Paste after cursor
P                            # Paste before cursor
u                            # Undo
Ctrl+r                      # Redo
.                            # Repeat last command
```

### Search and Replace
```
/<pattern>                   # Search forward
?<pattern>                   # Search backward
n                            # Next match
N                            # Previous match
:%s/old/new/g               # Replace all in file
:%s/old/new/gc              # Replace all with confirmation
```

### Window Splits
```
:split or :sp               # Horizontal split
:vsplit or :vsp             # Vertical split
Ctrl+w h/j/k/l              # Navigate splits
Ctrl+w w                     # Cycle through splits
Ctrl+w q                     # Close split
```

---

## 🤖 Codeium (AI Completion)

### Insert Mode Only
```
Tab                          # Accept suggestion
Ctrl+n                      # Next suggestion
Ctrl+p                      # Previous suggestion
Ctrl+x                      # Clear suggestion
```

### Commands
```
:Codeium Auth               # Authenticate
:Codeium Status             # Check status
```

---

## 📝 Markdown Preview

### Normal Mode
```
Space + mp                   # Start markdown preview
Space + ms                   # Stop markdown preview
```

### SSH Setup (Required)
```bash
# On local machine ~/.ssh/config:
Host home-dev
    LocalForward 8080 localhost:8080

# Then open in browser:
http://localhost:8080
```

---

## 📁 Oil.nvim (File Explorer)

### Open File Explorer
```
Space + e                    # Open file explorer in current directory
```

### Navigation (in Oil buffer)
```
Enter                        # Open file / Enter directory
-                            # Go to parent directory
_                            # Go to current working directory
g.                           # Toggle hidden files
g?                           # Show help
```

### File Operations (Vim-style)
```
dd                           # Delete file/directory (mark for deletion)
yy + p                       # Copy and paste file
cw                           # Rename file (change word)
o                            # Create new file/directory
:w                           # Save changes (apply to filesystem)
:q                           # Quit without saving changes
u                            # Undo changes (before :w)
```

### Bulk Operations
```
# Example: Rename multiple files
1. Visual Line mode (V) to select files
2. :s/old/new/g to replace text
3. :w to apply changes

# Example: Delete multiple files
1. Visual Line mode (V) to select files
2. d to mark for deletion
3. :w to confirm deletion
```

### Pro Tips
```
# Oil treats directories like text files:
# - Edit file names like normal text
# - Changes are previewed before :w
# - All vim motions work (w, b, f, t, etc.)
# - Visual mode for bulk operations
```

---

## 🔧 LSP (Language Server Protocol)

### Navigation
```
gd                           # Go to definition
gD                           # Go to declaration
gr                           # Find references
gi                           # Go to implementation
K                            # Show hover documentation
<leader>k                    # Show signature help
```

### Code Actions
```
<leader>rn                   # Rename symbol
<leader>ca                   # Code action (fix, refactor)
<leader>f                    # Format code
```

### Diagnostics (Errors/Warnings)
```
]d                           # Next diagnostic
[d                           # Previous diagnostic
<leader>d                    # Show diagnostic in floating window
```

### Completion (Insert Mode)
```
<CR>                         # Accept completion
Tab                          # Next completion item
Shift+Tab                    # Previous completion item
Ctrl+Space                   # Trigger completion manually
Ctrl+e                       # Abort completion
```

### Information
```
:LspInfo                     # Show LSP server status
```

### Supported Languages
- **Python**: pylsp (numpy, pandas support in project environments)
- **Rust**: rust-analyzer (cargo integration)
- **C++**: clangd (clang-tidy integration)

---

## 🌍 direnv (Project Environments)

### Automatic Environment Switching

direnv automatically loads project-specific environments when you enter a directory.

**Workflow:**
```bash
cd ~/work/python-project
# Automatically loads Python 3.11 + numpy environment
# Prompt shows: via ❄️ impure via 🐍 v3.11.14

cd ~
# Automatically returns to normal environment
```

### Setting Up a New Project

**1. Create project directory:**
```bash
mkdir ~/work/my-python-project
cd ~/work/my-python-project
```

**2. Create flake.nix:**
```nix
{
  description = "My Python project";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }: {
    devShells.x86_64-linux.default = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in pkgs.mkShell {
      packages = with pkgs; [
        python311
        python311Packages.numpy
        python311Packages.python-lsp-server
      ];
    };
  };
}
```

**3. Create .envrc:**
```bash
echo "use flake" > .envrc
direnv allow
```

**4. Done!** Environment auto-loads when you `cd` into the directory.

### Commands
```
direnv allow                 # Allow .envrc (first time only)
direnv reload                # Reload environment manually
direnv deny                  # Disable environment for this directory
```

### Indicators
```
# Starship shows active environment:
╰─via ❄️ impure via 🐍 v3.11.14 ❯   # In project environment
╰─via 🐍 v3.12.3 ❯                   # In normal environment
```

### Pro Tips
- Each project can have different Python/Rust/C++ versions
- LSP automatically uses the project's dependencies
- Changes to flake.nix: `nix develop` rebuilds, direnv auto-reloads
- Works seamlessly with tmux multiple panes

---

## 🧠 Claude Code Integration

### Recommended Workflow
```bash
# 1. Start tmux session
tmux new -s coding

# 2. Open nvim
nvim myproject/

# 3. Split vertically
Ctrl+b |

# 4. Start Claude Code in right pane
claude

# 5. Navigate between panes
Ctrl+b h                     # Go to nvim
Ctrl+b l                     # Go to Claude Code
Ctrl+b z                     # Toggle zoom on current pane
```

### Typical Flow
```
1. Edit in nvim (left pane)
2. Ctrl+b l → Ask Claude Code for help
3. Claude Code edits file
4. Ctrl+b h → Return to nvim
5. ✨ File auto-reloads
6. Review and continue editing
```

---

## 🔍 Which-Key

### Usage
```
Space                        # Wait 0.5s → Show available keybindings
Space + m                    # Show Markdown keybindings
:WhichKey                   # Show all keybindings
```

---

## 🎨 Quick Tips

### Copy from tmux to system clipboard
```
# Enter copy mode
Ctrl+b [

# Navigate and select text
Space (start) → move → Enter (copy)

# Paste in tmux
Ctrl+b ]

# For system clipboard, use mouse selection with Shift held
```

### Quick nvim config reload
```vim
:source ~/.config/nvim/init.lua
```

### Check if file is auto-reloading
```vim
:set autoread?              # Should show "autoread"
```

### tmux session management
```bash
# List all sessions
tmux ls

# Kill session
tmux kill-session -t <name>

# Rename session
Ctrl+b $
```

---

## 📂 File Locations

### Configuration Files
```
~/nix-home/
├── flake.nix               # Nix configuration
├── nvim/
│   ├── init.lua           # Neovim main config
│   └── lua/plugins/       # Plugin configs
├── tmux/
│   └── tmux.conf          # Tmux configuration
└── zsh/
    └── .zshrc             # Zsh configuration

~/.anthropic_key            # Claude API key (not in git)
~/.ssh/config               # SSH configuration (local)
```

### Apply Changes
```bash
# Nix configuration
cd ~/nix-home
nix run home-manager/master -- switch --flake .#home-dev

# Tmux (after editing tmux.conf)
Ctrl+b r

# Nvim (after editing init.lua)
:source ~/.config/nvim/init.lua

# Zsh (after editing .zshrc)
source ~/.zshrc
```

---

## 🚀 Common Workflows

### 1. Start New Project
```bash
tmux new -s myproject
cd ~/projects/myproject
nvim
Ctrl+b |
claude
```

### 2. Resume Session
```bash
tmux attach -t myproject
# All panes and windows are preserved!
```

### 3. Edit Markdown with Preview
```bash
# On local machine, ensure SSH port forwarding:
ssh -L 8080:localhost:8080 home-dev

# On remote machine:
nvim README.md
Space + mp
# Open http://localhost:8080 in local browser
```

### 4. Multi-pane Setup
```bash
# Create 3-pane layout
nvim                        # Main pane
Ctrl+b |                   # Split right
claude                      # Right pane: Claude Code
Ctrl+b h                   # Back to nvim
Ctrl+b -                   # Split down
# Bottom pane: git, tests, etc.
```

### 5. Project Development with direnv + LSP
```bash
# 1. Create and enter project
mkdir ~/work/ml-project
cd ~/work/ml-project
# → direnv auto-loads if .envrc exists

# 2. Start tmux session
tmux new -s ml

# 3. Open nvim (left pane)
nvim main.py
# → LSP auto-starts with project's Python + libraries

# 4. Split for testing (right pane)
Ctrl+b |
python main.py

# 5. Split for container builds (bottom-right)
Ctrl+b -
podman run -v ./:/app python:3.11 python /app/main.py

# All panes share the same project environment!
```

### 6. Hybrid Development (Host + Container)
```bash
# Host side: Edit with LSP
cd ~/work/myproject
nvim src/main.py
# → Full LSP support (completion, goto definition)

# Container side: Build and run
podman run -v ./:/app rust:latest cargo build --release

# Benefits:
# - Host: Fast LSP, no heavy dependencies
# - Container: Isolated build environment, reproducible
```

---

## 🆘 Troubleshooting

### File not auto-reloading in nvim
```vim
:checktime                  # Manually check for changes
```

### Codeium not working
```vim
:Codeium Auth              # Re-authenticate
:Codeium Status            # Check status
```

### tmux mouse not working
```bash
# Should be enabled by default
# If not, check tmux.conf has:
set -g mouse on
```

### Markdown preview not accessible
```bash
# Ensure SSH port forwarding is active
ssh -L 8080:localhost:8080 home-dev

# Check if preview is running
Space + mp
# URL should be displayed in nvim
```

---

## 📚 Learning Resources

### Neovim
- `:help` - Built-in help
- `:Tutor` - Interactive tutorial
- `:help motion` - Movement commands

### Tmux
- `Ctrl+b ?` - Show all keybindings
- `man tmux` - Manual page

### Practice
- `vimtutor` - Command-line vim tutorial
- Create test session to experiment with tmux layouts

---

**Pro Tip**: Print this cheatsheet or keep it open in a browser tab while learning!
