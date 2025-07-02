-- Crunchy nvim config written in lua

-- General bs
vim.wo.number = true
vim.opt.autochdir = true
vim.opt.clipboard = "unnamedplus"
vim.g.vimtex_view_method = 'zathura'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"

-- 4 spaces instead of tab
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Plugin manager install
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Actual plugins
plugins = {'navarasu/onedark.nvim',
        'ms-jpq/coq_nvim',
        'romgrk/barbar.nvim',
        'jiangmiao/auto-pairs',
        'lukas-reineke/indent-blankline.nvim',
        'nvim-tree/nvim-tree.lua',
        'nvim-tree/nvim-web-devicons',
        'lervag/vimtex',
        'lewis6991/gitsigns.nvim',
        'SirVer/ultisnips',
        { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
        {'junegunn/fzf', ['do'] = 'fzf#install()' },
        'junegunn/fzf.vim',
        {'neoclide/coc.nvim', branch = 'release'},
        {'nvim-treesitter/nvim-treesitter', ['do'] = ':TSUpdate'},
        {
            'MeanderingProgrammer/markdown.nvim',
            name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
            dependencies = { 'nvim-treesitter/nvim-treesitter' },
            config = function()
            require('render-markdown').setup({})
            end,
        }
    }

-- Plugin startup
require("lazy").setup(plugins, opts)
require("nvim-tree").setup()
require('gitsigns').setup()
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "c_sharp", "c", "bash" },
  sync_install = false,
  auto_install = true,
  ignore_install = { "javascript" },

  highlight = {
    enable = true,
    disable = { "latex", "rust" },
    additional_vim_regex_highlighting = { "latex", "markdown" },
  },
}

-- Colors
-- require("onedark").load()
vim.cmd.colorscheme("catppuccin")
vim.api.nvim_set_hl(0, "Normal", { bg=nil })
vim.api.nvim_set_hl(0, "NormalNC", { bg=nil })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg=nil })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg=nil })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg=nil })
vim.api.nvim_set_hl(0, "SignColumn", { bg=nil })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg=nil })

if vim.g.colors_name == "catppuccin-mocha" then
    vim.api.nvim_set_hl(0, "LineNr", { fg="#9399b2" })
    vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg="#181825" })
end

-- Keybinds
ntree_api = require("nvim-tree.api")
vim.keymap.set("n", "<leader>t", function() ntree_api.tree.toggle() end)

local open_code_term;
local session_type = os.getenv("XDG_SESSION_TYPE")
local current_desktop = os.getenv("XDG_CURRENT_DESKTOP")
if session_type == "x11" then
    open_code_term = "$TERM --class codeterm & sleep 0.2 && i3-msg '[class=\"codeterm\"] resize set width 650'"
elseif current_desktop == "Hyprland" then
    open_code_term = "$TERMCMD"
end
vim.keymap.set("n", "<leader>m", function() os.execute(open_code_term) end)
vim.keymap.set("n", "<C-h>", "<Cmd>BufferPrevious<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>BufferNext<CR>")
vim.keymap.set("n", "<A-q>", "<Cmd>BufferClose<CR>")

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
vim.keymap.set("i", "<Tab>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
vim.keymap.set("i", "<S-Tab>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
vim.keymap.set("n", "<leader>r", "<Cmd>RenderMarkdownToggle<CR>")

vim.keymap.set("n", "<leader>f", "<Cmd>Files<CR>")

-- Snippets
-- snippets in /home/$USER/.config/nvim/UltiSnips/
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<c-b>"
vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>"

