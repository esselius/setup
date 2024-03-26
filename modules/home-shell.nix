{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;

      shellAliases = {
        gcb = "git checkout -b";
        gs = "git status -sb";
        "gcan!" = "git commit -v -a --no-edit --amend";
        gcam = "git commit -a -m";
        gl = "git pull";
        gp = "git push";
        gpsup = "git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)";
        gpf = "git push --force-with-lease";
      };

      shellAbbrs = {
        gco = "git checkout";

        k = "kubectl";
        kcuc = "kubectl config use-context";
        kccc = "kubectl config current-context";

        rg = "rg -S --hidden --glob '!.git/*'";
      };

      shellInit = ''
        set -x DIRENV_LOG_FORMAT ""
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

        # For all those secrets
        if test -e ~/.config/fish/env.fish
          source ~/.config/fish/env.fish
        end
      '';

      plugins = [
        {
          name = "kubectl-completions";
          src = pkgs.fetchFromGitHub {
            owner = "evanlucas";
            repo = "fish-kubectl-completions";
            rev = "bbe3b831bcf8c0511fceb0607e4e7511c73e8c71";
            sha256 = "1r6wqvvvb755jkmlng1i085s7cj1psxmddqghm80x5573rkklfps";
            # date = 2021-01-21T11:57:06-06:00;
          };
        }
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        openstack.disabled = true;
        gcloud.disabled = true;
        vagrant.disabled = true;
        git_status.disabled = true;
        kubernetes.disabled = false;
      };
    };
  };

  home.sessionPath = [
    "$HOME/.krew/bin"
  ];
  home.sessionVariables = {
    DBT_USER = "peter.esselius@pagero.com";
  };
}
