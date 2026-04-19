{ pkgs, settings, ... }:

with settings;{

  imports = [
    ../home/programs/yazi
    ../home/programs/tmux
    ../home/programs/zoxide
    ../home/programs/nvim
    ../home/programs/nix-direnv
  ];

  home = {
    username = vps.user;
    homeDirectory = "/home/" + vps.user;
    stateVersion = systemS.stateVersion;
  };

  home.packages = (builtins.map (p: getPack p pkgs) (vps.packages));

  home.sessionPath = [
    "/home/${vps.user}/.local/bin"
    "/home/${vps.user}/.cargo/bin"
    "/home/${vps.user}/.go/bin"
  ];

  programs.starship.enable = true;
  programs.gh.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.git = {
    enable = true;
    settings.user = {
      name = vps.name;
      email = vps.email;
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      eval "$(starship init bash)"
      eval "$(zoxide init bash)"
      eval "$(direnv hook bash)"
    '';
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      cat = "bat";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  programs.home-manager.enable = true;
}
