{
  description = "My Home Manager setup (macOS + Ubuntu)";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }:
  let
    # ===== Common Home Manager configuration =====
    mkHome = { system, username, homeDir, extraModules ? [] }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [
          # Import common configuration
          ./common.nix

          ({ pkgs, lib, config, ... }: {
            home.username = username;
            home.homeDirectory = homeDir;
            home.stateVersion = "23.11";

            # Symlink nvim config from ~/nix-home/nvim/ to ~/.config/nvim/
            # Changes apply immediately without going through nix store
            home.activation.linkNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
              # Remove old nix-managed nvim config
              if [ -L "$HOME/.config/nvim/init.lua" ] || [ -L "$HOME/.config/nvim/lua" ]; then
                echo "Removing old nix-managed nvim config..."
                rm -rf "$HOME/.config/nvim"
              fi

              # Create symlink to nix-home/nvim
              if [ ! -e "$HOME/.config/nvim" ]; then
                echo "Creating symlink: ~/.config/nvim -> ~/nix-home/nvim"
                ln -sfn "$HOME/nix-home/nvim" "$HOME/.config/nvim"
              else
                echo "✓ nvim config already linked"
              fi
            '';

            # Symlink tmux config from ~/nix-home/tmux/ to ~/.config/tmux/
            home.activation.linkTmuxConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
              # Remove old nix-managed tmux config
              if [ -L "$HOME/.config/tmux/tmux.conf" ]; then
                echo "Removing old nix-managed tmux config..."
                rm -f "$HOME/.config/tmux/tmux.conf"
              fi

              # Create .config/tmux directory
              mkdir -p "$HOME/.config/tmux"

              # Create symlink to nix-home/tmux/
              if [ ! -e "$HOME/.config/tmux/tmux.conf" ]; then
                echo "Creating symlink: ~/.config/tmux/tmux.conf -> ~/nix-home/tmux/tmux.conf"
                ln -sfn "$HOME/nix-home/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
              else
                echo "✓ tmux config already linked"
              fi

              # Backup old ~/.tmux.conf if it exists
              if [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
                echo "Backing up old ~/.tmux.conf to ~/.tmux.conf.backup"
                mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
              fi
            '';

            # Symlink starship config from ~/nix-home/starship.toml to ~/.config/starship.toml
            home.activation.linkStarshipConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
              # Create symlink to starship.toml
              if [ ! -e "$HOME/.config/starship.toml" ]; then
                echo "Creating symlink: ~/.config/starship.toml -> ~/nix-home/starship.toml"
                ln -sfn "$HOME/nix-home/starship.toml" "$HOME/.config/starship.toml"
              else
                echo "✓ starship config already linked"
              fi
            '';

            # Symlink wezterm config from ~/nix-home/wezterm/ to ~/.config/wezterm/ (macOS only)
            home.activation.linkWeztermConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
              # Only link wezterm config on macOS
              if [[ "$OSTYPE" == "darwin"* ]]; then
                # Remove old nix-managed wezterm config if it's a symlink
                if [ -L "$HOME/.config/wezterm/wezterm.lua" ]; then
                  echo "Removing old nix-managed wezterm config..."
                  rm -f "$HOME/.config/wezterm/wezterm.lua"
                fi

                # Create .config/wezterm directory
                mkdir -p "$HOME/.config/wezterm"

                # Create symlink to nix-home/wezterm/wezterm.lua
                if [ ! -e "$HOME/.config/wezterm/wezterm.lua" ]; then
                  echo "Creating symlink: ~/.config/wezterm/wezterm.lua -> ~/nix-home/wezterm/wezterm.lua"
                  ln -sfn "$HOME/nix-home/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
                else
                  echo "✓ wezterm config already linked"
                fi
              fi
            '';
          })
        ] ++ extraModules;
      };
    # 環境変数からユーザ名を取得（フォールバック付き）
    username = builtins.getEnv "USER";
    homeDir = builtins.getEnv "HOME";
  in {
    homeConfigurations = {
      # ===== macOS (Apple Silicon) =====
      mac = mkHome {
        system = "aarch64-darwin";
        username = username;
        homeDir = homeDir;
        extraModules = [ ./mac.nix ];
      };
      # ===== Ubuntu / Linux =====
      home-dev = mkHome {
        system = "x86_64-linux";
        username = username;
        homeDir = homeDir;
        extraModules = [ ./home-dev.nix ];
      };
    };
  };
}
