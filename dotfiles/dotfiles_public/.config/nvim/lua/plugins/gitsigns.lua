return {  -- Adds git related signs to the gutter, as well as utilities for managing changes
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },             -- new lines
                change = { text = '~' },          -- changed lines
                delete = { text = '_' },          -- deleted lines
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },
}
