-- Neovim configuration to be used inside VS Code
require("config.lazy")

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- set clipboard to global clipboard
vim.opt.clipboard:append("unnamedplus")

require("lazy").setup({
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    vscode = true,
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "bash", "c", "html", "lua", "luadoc", "markdown", "vim",
          "vimdoc"
        },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true }, 
        -- indent = {enable = true, disable = {"ruby"}},
        incremental_selection = {
          enable = true,
          keymaps = {
            -- init_selection = "<CR>",
            -- scope_incremental = "<CR>",
            -- node_incremental = "<TAB>",
            -- node_decremental = "<S-TAB>"
            node_incremental = "v",
            node_decremental = "V",
          }
        }
      })
    end
  }
})

if vim.g.vscode then
  -- VSCode extension
  local api = vim.api

  api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
    group = api.nvim_create_augroup("vscode.treesitter", {}),
    callback = function()
      pcall(function()
        vim.treesitter.get_parser():parse()
      end)
    end,
  })
else
  -- ordinary Neovim
  vim.keymap.set("i", "jk", "<ESC>", { silent = true })
end
