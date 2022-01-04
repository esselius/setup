{ pkgs, ... }:
{
  programs = {
    ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "60m";
      controlPath = "/tmp/.ssh-%C";
    };

    git = {
      enable = true;
      lfs.enable = true;

      userName = "Peter Esselius";
      userEmail = "peter.esselius@pagero.com";

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
  };

  home.packages = [
    pkgs.gh

    (pkgs.writers.writeBashBin "github-repos" ''
      ${pkgs.gh}/bin/gh repo list "$1" -L 1000 --json sshUrl -q '.[].sshUrl'
    '')

    (pkgs.writers.writeBashBin "github-starred" ''
      ${pkgs.gh}/bin/gh api /user/starred --paginate -q '.[].ssh_url'
    '')

    (pkgs.writers.writeBashBin "github-sync" ''
      github-starred | ${pkgs.ghq}/bin/ghq get "$@"
      github-repos "$GITHUB_USER" | ${pkgs.ghq}/bin/ghq get "$@"

      for org in $GITHUB_ORGS; do
        github-repos "$org" | ${pkgs.ghq}/bin/ghq get "$@"
      done
    '')
  ];
}
