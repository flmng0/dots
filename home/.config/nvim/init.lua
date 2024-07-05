local function bootstrap(name, url, branch, ex_args)
	ex_args = ex_args or {}
	local path = vim.fn.stdpath("data") .. "/lazy/" .. name

	if not vim.loop.fs_stat(path) then
		local args = vim.iter({
			"git",
			"clone",
			"--filter=blob:none",
			"--branch=" .. branch,
			ex_args,
			url,
			path,
		})
		args:flatten()

		vim.fn.system(args)
	end

	vim.opt.rtp:prepend(path)
end

bootstrap("lazy.nvim", "https://github.com/folke/lazy.nvim.git", "stable")
bootstrap("hotpot.nvim", "https://github.com/rktjmp/hotpot.nvim.git", "v0.11.1")

require("hotpot").setup({
	provide_require_fennel = true,
	enable_hotpot_diagnostics = false,
})

require("tmthy")
