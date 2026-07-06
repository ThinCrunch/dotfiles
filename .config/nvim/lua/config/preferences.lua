-- General
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

-- Colors
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
vim.keymap.set("n", "<leader>t", "<Cmd>NvimTreeToggle<CR>")

local session_type = os.getenv("XDG_SESSION_TYPE")
local current_desktop = os.getenv("XDG_CURRENT_DESKTOP")
if session_type == "x11" then
    open_code_term = "$TERM --class codeterm & sleep 0.2 && i3-msg '[class=\"codeterm\"] resize set width 650'"
elseif current_desktop == "Hyprland" then
    open_code_term = os.getenv("TERM")
end
vim.keymap.set("n", "<leader>m", function() vim.system({open_code_term}) end)
vim.keymap.set("n", "<C-h>",     "<Cmd>BufferPrevious<CR>")
vim.keymap.set("n", "<S-C-h>",   "<Cmd>BufferMovePrevious<CR>")
vim.keymap.set("n", "<C-l>",     "<Cmd>BufferNext<CR>")
vim.keymap.set("n", "<S-C-l>",   "<Cmd>BufferMoveNext<CR>")
vim.keymap.set("n", "<A-q>",     "<Cmd>BufferClose<CR>")

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
--vim.keymap.set("i", "<Tab>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
--vim.keymap.set("i", "<S-Tab>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
vim.keymap.set("n", "<leader>r", "<Cmd>RenderMarkdownToggle<CR>")

vim.keymap.set("n", "<leader>f", "<Cmd>Files<CR>")

