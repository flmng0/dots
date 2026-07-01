(let [mise-shims (.. vim.env.HOME "/.local/share/mise/shims")]
    (set vim.env.PATH (.. mise-shims ":" vim.env.PATH)))

