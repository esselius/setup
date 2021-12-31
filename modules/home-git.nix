{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "60m";
    controlPath = "/tmp/.ssh-%C";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Peter Esselius";

    delta = {
      enable = true;
      options = {
        # features = "side-by-side line-numbers decorations";
        syntax-theme = "Solarized (light)";
      };
    };

    aliases = {
      l = "log --graph --decorate --pretty=format:\"%C(yellow)%h%C(reset)%C(auto)%d%C(reset) %s %C(yellow)(%C(cyan)%ar%C(yellow), %C(blue)%an%C(yellow))%C(reset)\"";
      ll = "log --graph --decorate --stat --pretty=format:\"%C(yellow)%h%C(reset)%C(auto)%d%C(reset) %s%n %C(cyan)%ar%C(reset), %C(blue)%an%C(reset)%n\"";
      wc = "whatchanged -p --abbrev-commit --pretty=medium";
      dc = "diff --cached";
      unstage = "reset HEAD";
      uncommit = "reset --soft HEAD^";
    };

    ignores = [
      ".*.swp"
      ".DS_Store"
      ".metals/"
      ".bloop/"
      ".vscode/"
    ];

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
      pull = {
        rebase = true;
      };
      push = {
        default = "simple";
      };
      color = {
        ui = "auto";
      };
      ghq = {
        root = "~/src";
      };
      url."git@github.com:".insteadOf = "https://github.com";
    };
  };
}
