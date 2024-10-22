require('tmthy.util').map_all({
	{ 'n', '<localleader>rr', '<Cmd>FlutterRun<CR>', desc = 'Start flutter session' },
	{ 'n', '<localleader>rl', '<Cmd>FlutterReload<CR>', desc = 'Reload flutter session' },
	{ 'n', '<localleader>rs', '<Cmd>FlutterRestart<CR>', desc = 'Restart flutter session' },
	{ 'n', '<localleader>Q', '<Cmd>FlutterQuit<CR>', desc = 'Quit flutter session' },
})
