local M = {}

M.diagnostics = {
    Error = '',
    Warn = '',
    Info = '',
    Hint = '',

}

function M.set_signs()
    for severity, icon in pairs(M.diagnostics) do
        local hl = 'Diagnostic'..severity
        vim.fn.sign_define(
            'DiagnosticSign'..severity,
            { text = icon, numhl = hl, texthl = hl }
        )
    end
end

return M
