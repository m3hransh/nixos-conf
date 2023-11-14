{  pkgs, ... }:

{
    # home.file.".config/Code/User/settings.json".source= ./settings.json;
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
      userSettings = builtins.fromJSON (builtins.readFile ./settings.json );
      keybindings = [
            {
              key= "ctrl+k e";
              command= "workbench.action.toggleSidebarVisibility";
            }
            {
              key= "ctrl+b";
              command= "-workbench.action.toggleSidebarVisibility";
            }
            {
              key = "ctrl+k b";
              command = "workbench.action.closeActiveEditor";
            }
            {
              key = "ctrl+w";
              command = "-workbench.action.closeActiveEditor";
            }
        ];
  };
}
