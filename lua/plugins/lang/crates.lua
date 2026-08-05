local Plugin = require("core.plugin")

local icons = {
    diagnostics = require("utils.icons").get("diagnostics", true),
    git = require("utils.icons").get("git", true),
    misc = require("utils.icons").get("misc", true),
    ui = require("utils.icons").get("ui", true),
    kind = require("utils.icons").get("kind", true),
}

return Plugin:new("Saecki/crates.nvim")
    :lazy(true)
    :on("BufReadPost Cargo.toml", "BufNewFile Cargo.toml")
    :dep("nvim-lua/plenary.nvim")
    :opts({
        smart_insert = true,
        insert_closing_quote = true,
        avoid_prerelease = true,
        autoload = true,
        autoupdate = true,
        autoupdate_throttle = 250,
        loading_indicator = true,
        date_format = "%Y-%m-%d",
        thousands_separator = ",",
        notification_title = "Crates",
        curl_args = { "-sL", "--retry", "1" },
        disable_invalid_feature_diagnostic = false,
        text = {
            loading = " " .. icons.misc.Watch .. "Loading",
            version = " " .. icons.ui.Check .. "%s",
            prerelease = " " .. icons.diagnostics.Warning_alt .. "%s",
            yanked = " " .. icons.diagnostics.Error .. "%s",
            nomatch = " " .. icons.diagnostics.Question .. "No match",
            upgrade = " " .. icons.diagnostics.Hint_alt .. "%s",
            error = " " .. icons.diagnostics.Error .. "Error fetching crate",
        },
        popup = {
            autofocus = false,
            hide_on_select = true,
            copy_register = '"',
            style = "minimal",
            border = "rounded",
            show_version_date = true,
            show_dependency_version = true,
            max_height = 30,
            min_width = 20,
            padding = 1,
            text = {
                title = icons.ui.Package .. "%s",
                description = "%s",
                created_label = icons.misc.Added .. "created" .. "        ",
                created = "%s",
                updated_label = icons.misc.ManUp .. "updated" .. "        ",
                updated = "%s",
                downloads_label = icons.ui.CloudDownload .. "downloads      ",
                downloads = "%s",
                homepage_label = icons.misc.Campass .. "homepage       ",
                homepage = "%s",
                repository_label = icons.git.Repo .. "repository     ",
                repository = "%s",
                documentation_label = icons.diagnostics.Information_alt .. "documentation  ",
                documentation = "%s",
                crates_io_label = icons.ui.Package .. "crates.io      ",
                crates_io = "%s",
                categories_label = icons.kind.Class .. "categories     ",
                keywords_label = icons.kind.Keyword .. "keywords       ",
                version = "  %s",
                prerelease = icons.diagnostics.Warning_alt .. "%s prerelease",
                yanked = icons.diagnostics.Error .. "%s yanked",
                version_date = "  %s",
                feature = "  %s",
                enabled = icons.ui.Play .. "%s",
                transitive = icons.ui.List .. "%s",
                normal_dependencies_title = icons.kind.Interface .. "Dependencies",
                build_dependencies_title = icons.misc.Gavel .. "Build dependencies",
                dev_dependencies_title = icons.misc.Glass .. "Dev dependencies",
                dependency = "  %s",
                optional = icons.ui.BigUnfilledCircle .. "%s",
                dependency_version = "  %s",
                loading = " " .. icons.misc.Watch,
            },
        },
        completion = {
            insert_closing_quote = true,
            text = {
                prerelease = " " .. icons.diagnostics.Warning_alt .. "pre-release ",
                yanked = " " .. icons.diagnostics.Error_alt .. "yanked ",
            },
        },
    })
    :local_keys({ event = { "BufReadPost", "BufNewFile" }, pattern = "Cargo.toml" }, function(_, bind)
        local crates = require("crates")
        return {
            ["n|<leader>ct"] = bind.map_callback(function()
                crates.toggle()
            end)
                :with_desc("crates: Toggle spec activities"),
            ["n|<leader>cr"] = bind.map_callback(function()
                crates.reload()
            end)
                :with_desc("crates: Reload crate specs"),

            ["n|<leader>cs"] = bind.map_callback(function()
                crates.show_popup()
            end)
                :with_desc("crates: Toggle pop-up window"),
            ["n|<leader>cv"] = bind.map_callback(function()
                crates.show_versions_popup()
                crates.show_popup()
            end)
                :with_desc("crates: Select spec versions"),
            ["n|<leader>cf"] = bind.map_callback(function()
                crates.show_features_popup()
                crates.show_popup()
            end)
                :with_desc("crates: Select spec features"),
            ["n|<leader>cd"] = bind.map_callback(function()
                crates.show_dependencies_popup()
                crates.show_popup()
            end)
                :with_desc("crates: Show project dependencies"),

            ["n|<leader>cu"] = bind.map_callback(function()
                crates.update_crate()
            end)
                :with_desc("crates: Update current crate's spec"),
            ["v|<leader>cu"] = bind.map_callback(function()
                crates.update_crates()
            end)
                :with_desc("crates: Update selected crate's spec"),
            ["n|<leader>ca"] = bind.map_callback(function()
                crates.update_all_crates()
            end)
                :with_desc("crates: Update all crates' specs"),
            ["n|<leader>cU"] = bind.map_callback(function()
                crates.upgrade_crate()
            end)
                :with_desc("crates: Upgrade current crate"),
            ["v|<leader>cU"] = bind.map_callback(function()
                crates.upgrade_crates()
            end)
                :with_desc("crates: Upgrade selected crates"),
            ["n|<leader>cA"] = bind.map_callback(function()
                crates.upgrade_all_crates()
            end)
                :with_desc("crates: Upgrade all crates"),

            ["n|<leader>cH"] = bind.map_callback(function()
                crates.open_homepage()
            end)
                :with_desc("crates: Open current crate's homepage"),
            ["n|<leader>cR"] = bind.map_callback(function()
                crates.open_repository()
            end)
                :with_desc("crates: Open current crate's repository"),
            ["n|<leader>cD"] = bind.map_callback(function()
                crates.open_documentation()
            end)
                :with_desc("crates: Open current crate's documentation"),
            ["n|<leader>cC"] = bind.map_callback(function()
                crates.open_crates_io()
            end)
                :with_desc("crates: Browse current crate on crates.io"),
        }
    end)
