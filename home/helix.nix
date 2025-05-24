{ pkgs, lib, ... }:
{
  programs.helix = {
    enable = true;

    languages.language = [
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
      {
        name = "haskell";
        auto-format = true;
        formatter.command = lib.getExe pkgs.fourmolu;
        language-servers = [
          "hls"
        ];
      }
      {
        name = "rust";
        auto-format = true;
        formatter.command = lib.getExe pkgs.rustfmt;
        language-servers = [
          "rust-analyzer"
        ];
      }
    ];

    languages.language-server = {
      nixd.command = lib.getExe pkgs.nixd;
      nil.command = lib.getExe pkgs.nil;
      hls.command = lib.getExe pkgs.haskell-language-server;
      rust-analyzer.command = lib.getExe pkgs.rust-analyzer;
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
}
