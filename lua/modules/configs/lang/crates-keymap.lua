---@diagnostic disable: undefined-field
local bind = require("keymap.bind")
local map_callback = bind.map_callback

local crates = require("crates")

local crates_keymap = {
    ["n|<leader>ct"] = map_callback(function()
            crates.toggle()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Toggle spec activities"),
    ["n|<leader>cr"] = map_callback(function()
            crates.reload()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Reload crate specs"),

    ["n|<leader>cs"] = map_callback(function()
            crates.show_popup()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Toggle pop-up window"),
    ["n|<leader>cv"] = map_callback(function()
            crates.show_versions_popup()
            crates.show_popup()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Select spec versions"),
    ["n|<leader>cf"] = map_callback(function()
            crates.show_features_popup()
            crates.show_popup()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Select spec features"),
    ["n|<leader>cd"] = map_callback(function()
            crates.show_dependencies_popup()
            crates.show_popup()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Show project dependencies"),

    ["n|<leader>cu"] = map_callback(function()
            crates.update_crate()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Update current crate's spec"),
    ["v|<leader>cu"] = map_callback(function()
            crates.update_crates()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Update selected crate's spec"),
    ["n|<leader>ca"] = map_callback(function()
            crates.update_all_crates()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Update all crates' specs"),
    ["n|<leader>cU"] = map_callback(function()
            crates.upgrade_crate()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Upgrade current crate"),
    ["v|<leader>cU"] = map_callback(function()
            crates.upgrade_crates()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Upgrade selected crates"),
    ["n|<leader>cA"] = map_callback(function()
            crates.upgrade_all_crates()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Upgrade all crates"),

    ["n|<leader>cH"] = map_callback(function()
            crates.open_homepage()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Open current crate's homepage"),
    ["n|<leader>cR"] = map_callback(function()
            crates.open_repository()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Open current crate's repository"),
    ["n|<leader>cD"] = map_callback(function()
            crates.open_documentation()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Open current crate's documentation"),
    ["n|<leader>cC"] = map_callback(function()
            crates.open_crates_io()
        end)
        :with_noremap()
        :with_silent()
        :with_buffer(0)
        :with_desc("crates: Browse current crate on crates.io"),
}

bind.nvim_load_mapping(crates_keymap)
