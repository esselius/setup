{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;

    userSettings = {
      editor.minimap.enabled = false;
      extensions.autoCheckUpdates = false;
      files.autoSave = "onFocusChange";
      terminal.integrated.scrollback = 10000;
      terminal.integrated.showExitAlert = false;
      update.showReleaseNotes = false;
      workbench.colorTheme = "GitHub Light";
      workbench.startupEditor = "none";
      jupyter.askForKernelRestart = false;
      editor.formatOnSave = true;
      explorer.confirmDelete = false;
      yaml.format.enable = true;
    };

    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      editorconfig.editorconfig
      github.copilot
      github.github-vscode-theme
      hashicorp.terraform
      jnoortheen.nix-ide
      ms-python.vscode-pylance
      vscodevim.vim
      ms-azuretools.vscode-docker
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-direnv";
        publisher = "rubymaniac";
        version = "0.0.2";
        sha256 = "sha256-TVvjKdKXeExpnyUh+fDPl+eSdlQzh7lt8xSfw1YgtL4=";
      }
      {
        name = "python";
        publisher = "ms-python";
        version = "2021.12.1559732655";
        sha256 = "sha256-hXTVZ7gbu234zyAg0ZrZPUo6oULB98apxe79U2yQHD4=";
      }
      {
        name = "editorconfiggenerator";
        publisher = "nepaul";
        version = "0.2.1";
        sha256 = "sha256-SHjcMnb2qvrRRbmAxfUEI37NavkS7bpKhYwNArMa3A4=";
      }
    ];
  };
}
