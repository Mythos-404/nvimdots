local global = {}
local os_name = vim.uv.os_uname().sysname

function global:load_variables()
	self.is_mac = os_name == "Darwin"
	self.is_linux = os_name == "Linux"
	self.is_windows = os_name == "Windows_NT"
	self.is_wsl = vim.fn.has("wsl") == 1
	self.vim_path = vim.fn.stdpath("config")
	self.data_dir = ("%s/site/"):format(vim.fn.stdpath("data"))
	self.cache_dir = vim.fn.stdpath("cache")
	self.modules_dir = self.vim_path .. "/modules"
	self.home = self.is_windows and os.getenv("USERPROFILE") or os.getenv("HOME")
end

global:load_variables()

return global
