-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Options
vim.g.mapleader = " "
vim.g.loaded_netrw = 1         -- nvim-tree と競合するので無効化
vim.g.loaded_netrwPlugin = 1

vim.opt.mouse = "a"            -- ★マウス
vim.opt.clipboard = "unnamedplus" -- ★yank/pasteがOSと共有される

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.updatetime = 300

-- Plugins
require("lazy").setup({
  { "nvim-tree/nvim-tree.lua",
    config = function() require("nvim-tree").setup({}) end },
  { "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" } },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "nvim-treesitter/nvim-treesitter",
    branch = "main", lazy = false, build = ":TSUpdate" },
})

-- LSP (Nvim 0.11+)
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
vim.lsp.enable({ "ts_ls", "pyright" })

-- Treesitter (main branch)
require("nvim-treesitter").install({
  "lua", "javascript", "typescript", "tsx", "python", "json",
})
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})

-- Completion
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args) vim.snippet.expand(args.body) end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- 未選択でEnterしても勝手に確定しない
  },
  sources = { { name = "nvim_lsp" } },
})

-- Keymaps
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>") -- Cursorっぽく
vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<CR>") -- 要ripgrep
