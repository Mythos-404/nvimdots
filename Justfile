set shell := ["bash", "-cu"]

default: format

alias f := format
alias l := lines
alias pu := plugin_update
alias pl := plugin_list
alias pc := plugin_clear

home_dir := env_var("HOME")
mason_bins := home_dir + "/.local/share/nvim/mason/bin"

stylua := if `command -v stylua &>> /dev/null;echo $?` != "0" { mason_bins + "/stylua" } else { "stylua" }

@format:
    {{stylua}} -f "{{ invocation_directory() }}/stylua.toml" .
    echo Format Done!

@lines:
    {{ if `command -v tokei &>> /dev/null;echo $?` != "0" { error("no install tokei") } else { "" } }}
    tokei

plugin_clear *$names:
    #!/usr/bin/env bash
    if [[ $names == "all" ]]; then
        [[ -d $HOME/.local/share/nvim/site/lazy  ]] && rm -rf $HOME/.local/share/nvim/site/lazy
    else
        for name in $names; do
            [[ -d $HOME/.local/share/nvim/site/lazy/${name} ]] && rm -rf $HOME/.local/share/nvim/site/lazy/${name}
        done
    fi

@plugin_list:
    eza --git --icons $HOME/.local/share/nvim/site/lazy

@plugin_update:
    nvim --headless "+Lazy! update" +qa
    git add ./lazy-lock.json && git commit -m "chore(lockfile): update lazy-lock file"
    echo Update plugin Done!
