{ pkgs, lib, ... }:
{

  programs = {

    # Better `cat`
    bat.enable = true;

    gpg.enable = !pkgs.stdenv.isDarwin;

    lazygit.enable = true;

    zoxide.enable = true;

    direnv = {
      enable = true;
    };

    # nix.gc = {
    #   automatic = true;
    # };

    atuin = {
      enable = true;
      enableNushellIntegration = true;
      settings = {
        show_tabs = false;
        style = "compact";
      };
    };
    helix = {
      enable = true;

      languages.language = [
        {
          name = "git-commit";
          rulers = [ 80 ];
        }
        {
          name = "markdown";
          soft-wrap.enable = true;
          soft-wrap.wrap-indicator = "";
          soft-wrap.wrap-at-text-width = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
          language-servers = [
            "nixd"
            "nil"
          ];
        }
      ];

      languages.language-server = {
        nixd.command = lib.getExe pkgs.nixd;
        nil.command = lib.getExe pkgs.nil;
      };

      settings = {
        theme = "gruvbox";
        editor = {
          # diagnostics
          end-of-line-diagnostics = "hint";
          inline-diagnostics.cursor-line = "error";

          bufferline = "multiple";
          color-modes = true;
          completion-replace = true;
          completion-timeout = 5;
          completion-trigger-len = 1;
          cursorline = true;
          cursor-shape.insert = "bar";
          file-picker.hidden = false;
          lsp.display-inlay-hints = true;
          preview-completion-insert = false;
        };

      };
    };
  };
}
