{ flake, ... }:
{
  imports = [
    flake.inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    plugins.lazygit.enable = true;

    plugins.nvim-tree.enable = true;
    keymaps = [
      {
        action = "<cmd>NvimTreeFindFileToggle<CR>";
        key = "<leader>tt";
      }
      {
        action = "<cmd>NvimTreeFindFile<CR>";
        key = "<leader>tf";
      }
      # Lazygit keymap
      {
        action = "<cmd>LazyGit<CR>";
        key = "<leader>gg";
      }
    ];


    # Theme
    colorschemes.gruvbox.enable = true;

    # Settings
    opts = {
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      number = true;
      clipboard = "unnamedplus";
    };

    # Keymaps
    globals = {
      mapleader = " ";
    };

    plugins = {

      # UI
      web-devicons.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      treesitter.enable = true;
      which-key = {
        enable = true;
      };
      noice = {
        # WARNING: This is considered experimental feature, but provides nice UX
        enable = true;
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          #inc_rename = false;
          #lsp_doc_border = false;
        };
      };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = {
            options.desc = "file finder";
            action = "find_files";
          };
          "<leader>fg" = {
            options.desc = "find via grep";
            action = "live_grep";
          };
          "<leader>fr" = {
            options.desc = "recent files";
            action = "oldfiles";
          };
        };
        extensions = {
          file-browser.enable = true;
          ui-select.enable = true;
          frecency.enable = true;
          fzf-native.enable = true;
        };
      };

      # Dev
      lsp = {
        enable = true;
        keymaps = {
          lspBuf = {
            "gd" = "definition";
            "gD" = "references";
            "gt" = "type_definition";
            "gi" = "implementation";
            "K" = "hover";
            "<leader>A" = "code_action";
          };
          diagnostic = {
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };
        };
        servers = {
          hls = {
            enable = true;
            installGhc = false;
          };
          marksman.enable = true;
          nil_ls.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };
    };
  };
}
