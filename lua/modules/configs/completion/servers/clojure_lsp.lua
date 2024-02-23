return function(option)
	local util = require("lspconfig").util
	require("lspconfig").clojure_lsp.setup({
		root_dir = function(fname)
			return util.root_pattern("deps.edn", "build.boot", "project.clj", "shadow-cljs.edn", "bb.edn", ".git")(
				fname
			) or util.path.dirname(fname)
		end,
		on_attach = option.on_attach,
		filetypes = { "clojure", "edn" },
		message_level = vim.lsp.protocol.MessageType.error,
		cmd = { "clojure-lsp" },
	})
end
