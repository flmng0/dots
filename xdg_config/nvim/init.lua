function bootstrap(name, url, branch, ex_args)
	local ex_args = ex_args or {}
	local path = vim.fn.stdpath("data") .. "/lazy/" .. name

	if not vim.loop.fs_stat(path) then
		args = vim.tbl_flatten({
			"git",
			"clone",
			"--filter=blob:none",
			ex_args,
			url,
			"--branch=" .. branch,
			path,
		})

		vim.fn.system(args)
	end

	vim.opt.rtp:prepend(path)
end

hotpotver = "v0.11.1"

bootstrap("lazy.nvim", "https://github.com/folke/lazy.nvim.git", "main")
bootstrap("hotpot.nvim", "https://github.com/rktjmp/hotpot.nvim.git", hotpotver, { "--single-branch" })

require("hotpot").setup()

require("tmthy")
