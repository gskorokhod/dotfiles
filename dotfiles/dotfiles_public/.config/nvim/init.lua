-- Install Lazy nvim - see https://github.com/folke/lazy.nvim
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

-- Config options for lazy
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

-- Source configs
-- note: we want keymaps etc to be defined before we load plugins
require('keymaps')  -- source lua/keymaps.lua - put key bindings there
require('options')  -- source lua/options.lua - put nvim config there

-- Run lazy and source plugins from lua/plugins directory
require("lazy").setup('plugins')

-- LSP setup
-- require('lsp')

-- Colour scheme
-- note: can't put this in lua/options.lua because we need to load plugins first!
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

