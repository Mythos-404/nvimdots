local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local helpers = require("keymap.helpers")

local builtin_map = {}

local edit_keys = {
    -- Save & Exit
    ["n|<C-s>"] = map_cu("write"):with_desc("edit: Save file"),
    ["n|<C-q>"] = map_cr("wq"):with_desc("edit: Save file and quit"),
    ["n|<A-S-q>"] = map_cr("q!"):with_desc("edit: Force quit"),

    -- Insert Mode
    ["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_desc("edit: Delete previous block"),
    ["i|<C-b>"] = map_cmd("<Left>"):with_desc("edit: Move cursor to left"),
    ["i|<C-a>"] = map_cmd("<ESC>^i"):with_desc("edit: Move cursor to line start"),
    ["i|<C-s>"] = map_cmd("<Esc>:w<CR>"):with_desc("edit: Save file"),
    ["i|<C-q>"] = map_cmd("<Esc>:wq<CR>"):with_desc("edit: Save file and quit"),

    -- Command Mode
    ["c|<C-b>"] = map_cmd("<Left>"):with_desc("edit: Left"),
    ["c|<C-f>"] = map_cmd("<Right>"):with_desc("edit: Right"),
    ["c|<C-a>"] = map_cmd("<Home>"):with_desc("edit: Home"),
    ["c|<C-e>"] = map_cmd("<End>"):with_desc("edit: End"),
    ["c|<C-d>"] = map_cmd("<Del>"):with_desc("edit: Delete"),
    ["c|<C-h>"] = map_cmd("<BS>"):with_desc("edit: Backspace"),
    ["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]])
        :with_desc("edit: Complete path of current file"),

    -- Editorial Enhancements
    ["n|Y"] = map_cmd("y$"):with_desc("edit: Yank text to EOL"),
    ["n|D"] = map_cmd("d$"):with_desc("edit: Delete text to EOL"),
    ["n|n"] = map_cmd("nzzzv"):with_desc("edit: Next search result"),
    ["n|N"] = map_cmd("Nzzzv"):with_desc("edit: Prev search result"),
    ["n|J"] = map_cmd("mzJ`z"):with_desc("edit: Join next line"),
    ["n|<S-Tab>"] = map_cr("normal za"):with_desc("edit: Toggle code fold"),
    ["n|<Esc>"] = map_callback(function()
            helpers.flash_esc_or_noh()
        end)
        :with_desc("edit: Clear search highlight"),
    ["n|<leader>o"] = map_cr("setlocal spell! spelllang=en_us"):with_desc("edit: Toggle spell check"),

    -- Generic LSP Switch
    ["n|<leader>lv"] = map_callback(function()
            helpers.toggle_virtualtext()
        end)
        :with_desc("lsp: Toggle virtual text"),
    ["n|<leader>lh"] = map_callback(function()
            helpers.toggle_inlayhint()
        end)
        :with_desc("lsp: Toggle inlay hints"),
}

for k, v in pairs(edit_keys) do
    builtin_map[k] = v
end

local ui_keys = {
    -- Buffer
    ["n|<leader>bn"] = map_cu("enew"):with_desc("buffer: New"),

    -- Terminal Windows Navigation
    ["t|<C-w>h"] = map_cmd("<Cmd>wincmd h<CR>"):with_desc("window: Focus left"),
    ["t|<C-w>l"] = map_cmd("<Cmd>wincmd l<CR>"):with_desc("window: Focus right"),
    ["t|<C-w>j"] = map_cmd("<Cmd>wincmd j<CR>"):with_desc("window: Focus down"),
    ["t|<C-w>k"] = map_cmd("<Cmd>wincmd k<CR>"):with_desc("window: Focus up"),

    -- Tab
    ["n|tn"] = map_cr("tabnew"):with_desc("tab: Create a new tab"),
    ["n|tk"] = map_cr("tabnext"):with_desc("tab: Move to next tab"),
    ["n|tj"] = map_cr("tabprevious"):with_desc("tab: Move to previous tab"),
    ["n|to"] = map_cr("tabonly"):with_desc("tab: Only keep current tab"),
}

for k, v in pairs(ui_keys) do
    builtin_map[k] = v
end

local lazy_keys = {
    ["n|<leader>ph"] = map_cr("Lazy"):with_nowait():with_desc("package: Show"),
    ["n|<leader>ps"] = map_cr("Lazy sync"):with_nowait():with_desc("package: Sync"),
    ["n|<leader>pu"] = map_cr("Lazy update"):with_nowait():with_desc("package: Update"),
    ["n|<leader>pi"] = map_cr("Lazy install"):with_nowait():with_desc("package: Install"),
    ["n|<leader>pl"] = map_cr("Lazy log"):with_nowait():with_desc("package: Log"),
    ["n|<leader>pc"] = map_cr("Lazy check"):with_nowait():with_desc("package: Check"),
    ["n|<leader>pd"] = map_cr("Lazy debug"):with_nowait():with_desc("package: Debug"),
    ["n|<leader>pp"] = map_cr("Lazy profile"):with_nowait():with_desc("package: Profile"),
    ["n|<leader>pr"] = map_cr("Lazy restore"):with_nowait():with_desc("package: Restore"),
    ["n|<leader>px"] = map_cr("Lazy clean"):with_nowait():with_desc("package: Clean"),
}

for k, v in pairs(lazy_keys) do
    builtin_map[k] = v
end

bind.nvim_load_mapping(builtin_map)
