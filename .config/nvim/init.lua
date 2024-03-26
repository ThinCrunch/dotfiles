-- Crunchy nvim config written in lua

-- General bs
vim.wo.number = true
vim.opt.autochdir = true
vim.opt.clipboard = "unnamedplus"

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
        {'neoclide/coc.nvim', branch = 'release'},
        {'nvim-treesitter/nvim-treesitter', ['do'] = ':TSUpdate'}}

-- Plugin startup
require("lazy").setup(plugins, opts)
require("nvim-tree").setup()
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "c_sharp", "c", "bash" },
  sync_install = false,
  auto_install = true,
  ignore_install = { "javascript" },

  highlight = {
    enable = true,
    disable = { "c", "rust" },
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    additional_vim_regex_highlighting = false,
  },
}

-- Colors
require("onedark").load()
vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")
vim.cmd("highlight EndOfBuffer ctermbg=NONE guibg=NONE")
vim.cmd("highlight NvimTreeNormal ctermbg=NONE guibg=NONE")
vim.cmd("highlight NvimTreeEndOfBuffer ctermbg=NONE guibg=NONE")

-- Keybinds
ntree_api = require("nvim-tree.api")
vim.keymap.set("n", "<leader>t", function() ntree_api.tree.toggle() end)
vim.keymap.set("n", "<leader>m", function() os.execute("alacritty &") end)
vim.keymap.set("n", "<C-h>", "<Cmd>BufferPrevious<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>BufferNext<CR>")
vim.keymap.set("n", "<C-q>", "<Cmd>BufferClose<CR>")
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
vim.keymap.set("i", "<Tab>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
vim.keymap.set("i", "<S-Tab>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)

