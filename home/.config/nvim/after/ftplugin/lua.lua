local wk = require('which-key')

wk.add({
	hidden = true,
	{ '<C-s>', [[<Cmd>source %<CR>]], desc = 'Source current lua file', buffer = true },
})
