-- Trusted project-local configs
-- Sources .nvim.lua files only in trusted project paths
--
-- Set trusted paths via environment variable in ~/.config/fish/private.fish:
--   set -gx NVIM_TRUSTED_PROJECTS "$HOME/project1:$HOME/project2"
-- Paths are colon-separated (like PATH)

local function get_trusted_projects()
	local env = vim.env.NVIM_TRUSTED_PROJECTS or ""
	if env == "" then
		return {}
	end
	return vim.split(env, ":", { plain = true, trimempty = true })
end

local function is_trusted(cwd)
	for _, trusted in ipairs(get_trusted_projects()) do
		local expanded = vim.fn.expand(trusted)
		if cwd == expanded or cwd:find("^" .. vim.pesc(expanded) .. "/") then
			return expanded
		end
	end
	return nil
end

local function try_source(trusted_path)
	local exrc = trusted_path .. "/.nvim.lua"
	if vim.fn.filereadable(exrc) == 1 then
		dofile(exrc)
		return true
	end
	return false
end

-- Source on directory change
vim.api.nvim_create_autocmd("DirChanged", {
	desc = "Source .nvim.lua for trusted projects",
	group = vim.api.nvim_create_augroup("trusted-exrc", { clear = true }),
	callback = function()
		local trusted = is_trusted(vim.fn.getcwd())
		if trusted then
			try_source(trusted)
		end
	end,
})

-- Source on startup
local trusted = is_trusted(vim.fn.getcwd())
if trusted then
	vim.schedule(function()
		try_source(trusted)
	end)
end
