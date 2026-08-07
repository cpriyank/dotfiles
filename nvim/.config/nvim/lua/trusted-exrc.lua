-- Trusted project-local configs
-- Automatically sources .nvim.lua or .exrc files in project roots
-- Uses Neovim's built-in 'exrc' with trust management

-- Enable exrc (project-local config files)
vim.opt.exrc = true

-- Create command to trust current directory's local config
vim.api.nvim_create_user_command("TrustExrc", function()
	local cwd = vim.fn.getcwd()
	local exrc = cwd .. "/.nvim.lua"
	local vimrc = cwd .. "/.exrc"

	if vim.fn.filereadable(exrc) == 1 then
		vim.secure.trust({ path = exrc, action = "allow" })
		vim.notify("Trusted: " .. exrc, vim.log.levels.INFO)
	elseif vim.fn.filereadable(vimrc) == 1 then
		vim.secure.trust({ path = vimrc, action = "allow" })
		vim.notify("Trusted: " .. vimrc, vim.log.levels.INFO)
	else
		vim.notify("No .nvim.lua or .exrc found in " .. cwd, vim.log.levels.WARN)
	end
end, { desc = "Trust local .nvim.lua or .exrc file" })

-- Create command to deny/revoke trust
vim.api.nvim_create_user_command("DenyExrc", function()
	local cwd = vim.fn.getcwd()
	local exrc = cwd .. "/.nvim.lua"
	local vimrc = cwd .. "/.exrc"

	if vim.fn.filereadable(exrc) == 1 then
		vim.secure.trust({ path = exrc, action = "deny" })
		vim.notify("Denied: " .. exrc, vim.log.levels.INFO)
	elseif vim.fn.filereadable(vimrc) == 1 then
		vim.secure.trust({ path = vimrc, action = "deny" })
		vim.notify("Denied: " .. vimrc, vim.log.levels.INFO)
	end
end, { desc = "Deny trust for local .nvim.lua or .exrc file" })
