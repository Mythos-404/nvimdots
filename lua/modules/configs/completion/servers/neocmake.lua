return {
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = false,
				},
			},
		},
	},
	init_options = {
		format = {
			enable = true,
		},
		scan_cmake_in_package = false,
		semantic_token = false,
	},
}
