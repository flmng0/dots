local M = {}

local flutter_actions = {
    ['Run'] = { desc = 'Run the current project', exec = 'FlutterRun' },
    ['Quit'] = { desc = 'End the running session', exec = 'FlutterQuit' },
    ['Detach'] = {
        desc = 'End a running session but keep the project running',
        exec = 'FlutterDetach',
    },
    ['Devices'] = { desc = 'Show connected devices', exec = 'FlutterDevices' },
    ['Open Outline'] = { desc = 'Open the file outline pane', exec = 'FlutterOutlineOpen' },
    ['Copy Profiler URL'] = {
        desc = 'Copy the active profiler URL to clipboard',
        exec = 'FlutterCopyProfilerUrl',
    },
}

M.choose_flutter_action = function()
    local items = vim.tbl_keys(flutter_actions)
    vim.ui.select(items, {
        prompt = 'Flutter:',
        format_item = function(item)
            return item .. ': ' .. flutter_actions[item].desc
        end,
    }, function(choice)
        if choice == nil then
            return
        end
        vim.cmd(flutter_actions[choice].exec)
    end)
end

return M
