local header = {
    type = 'text',
    val = {
        [[     ███                       ███      ███                  ]],
        [[    ░███                      ░███     ░███                  ]],
        [[   ███████     ███████████   ███████   ░███████    ███  ███  ]],
        [[  ░░░███░     ███░░███░░███ ░░░███░    ░███░░███  ░███ ░███  ]],
        [[    ░███     ░███ ░███ ░███   ░███     ░███ ░███  ░███ ░███  ]],
        [[    ░███ ██  ░███ ░███ ░███   ░███ ██  ░███ ░███  ░███ ░███  ]],
        [[    ░░█████  ░███ ░███ ░███   ░░█████  ░███ ░███  ░░███████  ]],
        [[     ░░░░░   ░░░  ░░░  ░░░     ░░░░░   ░░░  ░░░    ░░░░░███  ]],
        [[                                                   ███ ░███  ]],
        [[                                                  ░░██████   ]],
        [[                                                   ░░░░░░    ]],
    },
    opts = {
        position = 'center',
        hl = 'Type',
    }
}

local button_width = 55
local leader = 'SPC'
local ellipsis = '...'

local function button(sc, text, command, custom_opts)
    local sc_ = sc:gsub('%s', ''):gsub(leader, '<leader>')
    local shortcut = '[' .. sc .. ']'

    if #text >= button_width - #shortcut then
        text = text:sub(1, button_width - #shortcut - #ellipsis - 1) .. ellipsis
    end

    local opts = {
        position = 'center',
        shortcut = '[' .. sc .. '] ',
        cursor = 0,
        width = button_width,
        align_shortcut = 'right',
        shrink_margin = false,
        hl_shortcut = {
            { "Operator", 0, 1 },
            { "Number", 1, #sc + 1 },
            { "Operator", #sc + 1, #sc + 2 }
        },
    }

    if custom_opts then
        opts = vim.tbl_deep_extend('force', opts, custom_opts)
    end

    local keybind_opts = {
        noremap = false,
        silent = true,
        nowait = true,
    }

    opts.keymap = {
        'n',
        sc_,
        '<Cmd>' .. command .. '<CR>',
        keybind_opts,
    }


    local function on_press()
        vim.cmd(command)
    end

    return {
        type = 'button',
        val = text,
        on_press = on_press,
        opts = opts,
    }
end

local function title(text, custom_opts)
    local opts = vim.tbl_deep_extend('force', {
        hl = 'Title',
        position = 'center',
    }, custom_opts or {})

    return {
        type = 'text',
        val = text,
        opts = opts,
    }
end

local function group(label, opts_list, label_opts)
    local val = {
        title(label, label_opts),
        { type = 'padding', val = 1 },
    }
    local offset = #val

    for i, opts in ipairs(opts_list) do
        val[i + offset] = button(unpack(opts))
    end

    return {
        type = 'group',
        val = val,
        opts = {
            position = 'center',
        }
    }
end

local function shortcuts(configs)
    local shortcut_buttons = {}

    for i, config in ipairs(configs) do
        local opts = config[4] or {}
        local merged_opts = vim.tbl_extend('force', { hl = 'Identifier' }, opts)
        shortcut_buttons[i] = {
            config[1],
            config[2],
            config[3],
            merged_opts,
        }
    end

    return group('Shortcuts', shortcut_buttons)
end

local function glob_buttons(root_path, group_name, sc_prefix)
    local glob_pattern = 'find "%s" -mindepth 1 -maxdepth 1 -type d'
    if vim.fn.executable('fd') then
        glob_pattern = 'fd . "%s" --max-depth 1 --type d'
    end
    local glob_cmd = string.format('`' .. glob_pattern .. '`', root_path)
    local dirs = vim.fn.glob(glob_cmd, true, true)

    table.sort(dirs, function(a, b)
        local astat = vim.loop.fs_stat(a)
        local bstat = vim.loop.fs_stat(b)

        return astat.mtime.sec > bstat.mtime.sec
    end)

    local buttons_opts = {}
    for i, path in ipairs(dirs) do
        -- Shortcut for the button
        local sc = sc_prefix and sc_prefix .. ' ' .. tostring(i) or tostring(i)

        -- Get shortened path
        local modded = vim.fn.fnamemodify(path, ':~')
        if modded:sub(-1):find('[/\\]') then
            modded = modded:sub(1, -2)
        end
        local parent = modded:match('.*[/\\]')
        local project_name = modded:sub(#parent + 1)

        -- TODO: Figure out why this is still weird with margin set,
        --      and find a good solution for -1 applying to the full
        --      line instead of to the end of the text?
        local opts = {
            hl = {
                { 'Comment', 0, #modded - #project_name },
                { 'Keyword', #modded - #project_name, #modded },
            },
        }

        buttons_opts[i] = {
            sc,
            modded,
            'edit ' .. path .. ' | cd ' .. path,
            opts,
        }
    end

    return group(group_name, buttons_opts)
end

local projects_path = vim.fn.expand('$HOME/code')
local external_path = vim.fn.expand('$HOME/ext')

return {
    'goolord/alpha-nvim',
    -- dir = '~/code/alpha-nvim',
    -- name = 'alpha',
    cond = vim.fn.argc() == 0,
    lazy = false,
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    new_project = function()
        vim.ui.input({ label = 'Project Name:' }, function(name)
            if not name then
                vim.notify('No Project Name Provided, Canceling')
                return
            end

            local project_dir = projects_path .. '/' .. name
            vim.fn.mkdir(project_dir, 'p')
            vim.cmd('edit ' .. project_dir)
        end)
    end,

    new_external = function()
        vim.ui.input({ label = 'Repository Path:' }, function(url)
            if not url then
                vim.notify('No Reposity URL Provided, Canceling')
                return
            end

            local parts = vim.split(url, '/', {})
            local partn = #parts

            if partn == 2 then
                url = 'git@github.com:' .. url
                vim.notify('Treating Repository Path as "user/repo" pair, and cloning: ' .. url)
            end

            local last = parts[partn]:gsub('.git', '')
            local out_path = external_path .. '/' .. last

            vim.notify(vim.fn.system({
                'git',
                'clone',
                url,
                out_path
            }))

            vim.cmd('edit ' .. out_path)
        end)
    end,

    config = function()
        local alpha = require('alpha')

        alpha.setup {
            layout = {
                { type = 'padding', val = 2 },
                header,
                { type = 'padding', val = 2 },
                shortcuts({
                    { 'c', 'Edit NeoVim Config', 'edit ' .. vim.fn.stdpath('config') },
                    { 'n p', 'Create New Project', 'lua require("plugins.alpha").new_project()' },
                    { 'n x', 'Clone New External Project', 'lua require("plugins.alpha").new_external()' },
                }),
                { type = 'padding', val = 2 },
                glob_buttons(projects_path, 'Projects', 'p'),
                { type = 'padding', val = 2 },
                glob_buttons(external_path, 'External Projects', 'x'),
            },
            opts = {
                -- margin = 3,
            }
        }
    end,
}
