require('which-key').add({
	buffer = 0,
	{ '<localleader>rr', '<Cmd>FlutterRun<CR>', desc = 'Start flutter session' },
	{ '<localleader>rl', '<Cmd>FlutterReload<CR>', desc = 'Reload flutter session' },
	{ '<localleader>rs', '<Cmd>FlutterRestart<CR>', desc = 'Restart flutter session' },
	{ '<localleader>Q', '<Cmd>FlutterQuit<CR>', desc = 'Quit flutter session' },
})
