local fn = vim.fn

local source_repo = 'wbthomason/packer.nvim'
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local source = 'https://github.com/' .. source_repo

local was_bootstrap = false

if fn.empty(fn.glob(install_path)) > 0 then
    was_bootstrap = true
    fn.system({ 'git', 'clone', '--depth', '1', source, install_path })
    vim.cmd [[packadd packer.nvim]]
end

local packer = require('packer')

packer.init {
    display = {
        open_fn = function()
            return require('packer.util').float { border = 'rounded' }
        end
    },
    git = {
        clone_timeout = 300
    }
}


return packer.startup(function(use)
    -- packer can manage itself
    use 'wbthomason/packer.nvim'

    -- color scheme
    -- use {
    --     'folke/tokyonight.nvim',
    --     config = function()
    --         vim.cmd [[colorscheme tokyonight]]
    --     end
    -- }
    use {
        'navarasu/onedark.nvim',
        config = function()
            vim.cmd [[colorscheme onedark]]
        end
    }

    -- Telescope... very good
    use {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = {
            { 'nvim-lua/plenary.nvim' }
        }
    }

    -- file tree.. just in case
    use {
        'nvim-tree/nvim-tree.lua',
        requires = { 'nvim-tree/nvim-web-devicons' },
        tag = 'nightly',
    }

    -- comment toggling
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- surround keybinds
    use {
        'kylechui/nvim-surround',
        tag = '*',
        config = function()
            require('nvim-surround').setup()
        end
    }

    -- buffer line (pseudo-tabs)
    use {
        'akinsho/bufferline.nvim',
        tag = 'v3.*',
        requires = { 'nvim-tree/nvim-web-devicons' }
    }

    -- better prompt line
    use { 'nvim-lualine/lualine.nvim' }

    -- better splits
    use { 'mrjones2014/smart-splits.nvim' }

    -- treesitter!!!
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').update {
                with_sync = true
            }
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter'
    }

    -- lsp configurator thingy
    use {
        'neovim/nvim-lspconfig',
        requires = {
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            { 'j-hui/fidget.nvim' }
        }
    }

    -- completion engine
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },

            -- snippet engine
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },

            -- for devicons as kind
            { 'nvim-tree/nvim-web-devicons' },
            { 'onsails/lspkind.nvim' }
        }
    }

    -- sync if first launch
    if was_bootstrap then
        packer.sync()
    end
end)
