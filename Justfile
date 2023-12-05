set shell := ["bash", "-cu"]

default: format

alias f := format
alias l := lint

home_dir := env_var("HOME")
mason_bins := home_dir + "/.local/share/nvim/mason/bin"

stylua := if `command -v stylua &>> /dev/null;echo $?` != "0" { mason_bins + "/stylua" } else { "stylua" }
luacheck := if `command -v luacheck &>> /dev/null;echo $?` != "0" { mason_bins + "/luacheck" } else { "luacheck" }
lua_ls := if `command -v lua-language-server &>> /dev/null;echo $?` != "0" { mason_bins + "/lua-language-server" } else { "lua-language-server" }

@format:
    {{stylua}} -f "{{ invocation_directory() }}/stylua.toml" .
    echo Format Done!

lint: _lint_lua_ls _lint_luacheck

@lines:
    {{ if `command -v tokei &>> /dev/null;echo $?` != "0" { error("no install tokei") } else { "" } }}
    tokei

plugin_clear +name:
    if [[ {{ name }} == "all" ]]; then \
        rm -ri $HOME/.local/share/nvim/site/lazy; \
    else \
        rm -ri $HOME/.local/share/nvim/site/lazy/{{ name }}; \
    fi

@plugin_list:
    eza --git --icons $HOME/.local/share/nvim/site/lazy

@plugin_update:
    nvim --headless "+Lazy! update" +qa
    git add ./lazy-lock.json && git commit -m "chore(lockfile): update lazy-lock file"
    echo Update plugin Done!

[no-exit-message]
@_lint_luacheck:
    {{luacheck}} --std luajit --globals vim _toggle_lazygit _command_panel _flash_esc_or_noh _debugging --max-line-length 150 --no-config .


@_lint_lua_ls:
    {{lua_ls}} --chcklevel=Warning --check lua/
