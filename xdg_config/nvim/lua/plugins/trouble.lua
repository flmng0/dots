return {
    'folke/trouble.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    config = true,

    init = function()
        local utils = require('tmthy.utils')
        local nmap = utils.nmap
        local cmd = utils.cmd

        nmap('<leader>xx', cmd('TroubleToggle'), '[Trouble] Toggle Preview')
        nmap(
            '<leader>xw',
            cmd('TroubleToggle workspace_diagnostics'),
            '[Trouble] Toggle Workspace Diagnostics'
        )
        nmap(
            '<leader>xd',
            cmd('TroubleToggle document_diagnostics'),
            '[Trouble] Toggle Document Diagnostics'
        )
        nmap('<leader>xq', cmd('TroubleToggle quickfix'), '[Trouble] Toggle Quickfix Preview')
        nmap('<leader>xl', cmd('TroubleToggle loclist'), '[Trouble] Toggle Location List')
        -- TODO: Change the mapping to <leader>gr if it's gucci
        nmap('<leader>gr', cmd('TroubleToggle lsp_references'), '[Trouble] Toggle LSP References')
    end,
}
