-- set <space> as the leader key
vim.g.mapleader = " "

-- bootstrapping lazy.nvim
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

-- all the plugins and their respective config
local plugins = {	
    -- autodetect whitespace settings
    'tpope/vim-sleuth',
    -- display pending keybinds
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },
    -- theme (maybe switch to monokai later)
    { 'Mofiqul/dracula.nvim', name = "dracula", priority = 1000 },
    -- telescope (fuzzy finder)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    -- highlight and navigate code based on AST
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
}

-- start lazy.nvim with all the plugins and opts
require("lazy").setup(plugins, {})

-- customizing theme
require("dracula").setup( { transparent_bg = true } )
vim.cmd.colorscheme "dracula"

-- configure telescope
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- configure treesitter
-- deferring to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
    require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'go', 'lua', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },
        highlight = { enable = true },
        indent = { enable = true },
    }
end, 0)

-- modeline to shorthand the tab settings
-- vim: ts=4 sw=4 et
