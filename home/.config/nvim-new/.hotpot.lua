local allowed_globals = {}
for key, _ in pairs(_G) do
	table.insert(allowed_globals, key)
end

local function build(dirname)
	return { dirname..'/**/*.fnl', function(path)
		return string.gsub(path, "/"..dirname.."/", "/.compiled/"..dirname.."/")
	end }
end

return {
	build = {
		{ 'fnl/**/*macro*.fnl', false },
		{ 'fnl/**/*.fnl', function(path)
			return string.gsub(path, [[/fnl/]], [[/.compiled/lua/]])
		end},
		build('after'),
		build('lsp'),
	},
	clean = {{".compiled/lua/**/*.lua", true}},
	compiler = {
		modules = {
			allowedGlobals = allowed_globals,
		},
	},
}
