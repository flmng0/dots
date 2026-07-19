local uv = vim.uv

---@param cb fun(stat: uv.fs_stat.result)
local function stat_file(path, cb)
	---@diagnostic disable: redefined-local
	uv.fs_open(path, 'r', tonumber('644', 8), function(err, fd)
		assert(not err, err)
		uv.fs_fstat(fd, function(err, stat)
			assert(not err, err)
			uv.fs_close(fd, function(err)
				assert(not err, err)
				return cb(stat)
			end)
		end)
	end)
end

local function make_file_describer(label, path)
	---@type brandon.blink.ResolveDescription
	return function(cb)
		local lines = {
			"**Name**: " .. label,
			"**Full Path**: " .. path
		}

		local function send_lines()
			cb(vim.iter(lines):join('\n'))
		end

		local okay, err = pcall(stat_file, path, function(stat)
			local size = "**Size**: " .. stat.size
			table.insert(lines, size)
			send_lines()
		end)

		if not okay then
			local err = "**Error**: " .. err
			table.insert(lines, err)
			send_lines()
		end
	end
end

local function file_to_context(path)
	local label = vim.fs.basename(path)
	if label == nil or #label == 0 then
		label = path
	end

	---@type brandon.blink.ContextItem
	return {
		label = label,
		description = make_file_describer(label, path),
		context = {
			name = label,
			file_path = path,
			type = 'file',
		}
	}
end

---@param cwd string
---@param callback fun(items: brandon.blink.ContextItem[])
local function try_fdfind(cwd, callback)
	local obj = vim.system({ 'fd', '--hidden', '--type', 'file' }, {
		cwd = cwd,
		text = true,
	}, function(out)
		if out.code ~= 0 then
			callback({})
			return
		end

		local iter = vim.iter(vim.gsplit(out.stdout, '\n')):map(file_to_context)
		callback(iter:totable())
	end)

	return function()
		obj:kill("sigint")
		obj:wait(200)
	end
end

---@type brandon.blink.GetCompletions
return function(_, callback)
	vim.print('Calling file completions!')
	local cwd = vim.uv.cwd()
	if cwd == nil then
		callback({})
		return
	end

	local success, cancel = pcall(try_fdfind, cwd, callback)
	if success then
		return cancel
	end

	local iter = vim.iter(vim.fs.dir(cwd, { depth = 8 })):filter(function(path)
		local stat = vim.uv.fs_stat(path)
		return stat ~= nil and stat.type == "file"
	end):map(file_to_context)

	callback(iter:totable())

	return function() end
end
