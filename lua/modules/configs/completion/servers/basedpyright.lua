return {
	cmd_env = { LANG = "zh-cn" },
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			disableTaggedHints = false,

			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				autoImportCompletions = true,
				diagnosticMode = "openFilesOnly",

				typeCheckingMode = "all",
				diagnosticSeverityOverrides = {
					reportAny = false,
					reportUnusedCallResult = false,
					reportUnknownLambdaType = false,
					reportUnknownArgumentType = false,
					reportUnknownMemberType = false,
					reportDeprecated = "information",
					reportMissingTypeStubs = "information",
					reportUnknownVariableType = "information",
					reportUnusedExpression = "information",
					reportUnusedImport = "information",
				},
			},
		},
	},
}
