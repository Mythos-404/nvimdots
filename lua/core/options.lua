local global = require("core.global")

local function load_options()
    local global_local = {
        autoindent = true,
        autoread = true,
        autowrite = true,
        backspace = "indent,eol,start",
        backup = false,
        backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim",
        breakat = [[\ \	;:,!?]],
        breakindentopt = "shift:2,min:20",
        clipboard = "unnamedplus",
        cmdheight = 1, -- 0, 1, 2
        cmdwinheight = 5,
        complete = ".,w,b,k,kspell",
        completeopt = "fuzzy,menuone,noselect,popup",
        concealcursor = "c",
        conceallevel = 0,
        cursorcolumn = true,
        cursorline = true,
        diffopt = "filler,iwhite,internal,linematch:60,algorithm:patience",
        display = "lastline",
        encoding = "utf-8",
        equalalways = false,
        errorbells = true,
        expandtab = true,
        fileformats = "unix,mac,dos",
        foldenable = true,
        foldcolumn = "1",
        foldlevel = 99,
        foldlevelstart = 99,
        fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
        formatoptions = "1jcroql",
        grepformat = "%f:%l:%c:%m",
        grepprg = "rg --hidden --vimgrep --smart-case --",
        helpheight = 12,
        hidden = true,
        history = 2000,
        ignorecase = true,
        inccommand = "split",
        incsearch = true,
        infercase = true,
        jumpoptions = "stack",
        laststatus = 3,
        linebreak = true,
        list = true,
        listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",
        magic = true,
        mousescroll = "ver:3,hor:6",
        number = true,
        previewheight = 12,
        -- Do NOT adjust the following option (pumblend) if you're using transparent background
        pumblend = 0,
        pumheight = 15,
        redrawtime = 1500,
        relativenumber = true,
        ruler = true,
        scrolloff = 2,
        sessionoptions = "buffers,curdir,folds,help,tabpages,winpos,winsize",
        shada = "!,'500,<50,@100,s10,h",
        shiftround = true,
        shiftwidth = 4,
        shortmess = "aoOTIcF",
        showbreak = "↳  ",
        showcmd = false,
        showmode = false,
        showtabline = 2,
        sidescrolloff = 5,
        signcolumn = "yes",
        smartcase = true,
        smarttab = true,
        smoothscroll = true,
        splitbelow = true,
        splitkeep = "screen",
        splitright = true,
        startofline = false,
        swapfile = false,
        switchbuf = "usetab,uselast",
        synmaxcol = 2500,
        tabstop = 4,
        termguicolors = true,
        timeout = true,
        timeoutlen = 300,
        ttimeout = true,
        ttimeoutlen = 0,
        undodir = global.cache_dir .. "/undo/",
        undofile = true,
        -- Please do NOT set `updatetime` to above 500, otherwise most plugins may not function correctly
        updatetime = 200,
        viewoptions = "folds,cursor,curdir,slash,unix",
        virtualedit = "block",
        visualbell = true,
        whichwrap = "h,l,<,>,[,],~",
        wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
        wildignorecase = true,
        -- Do NOT adjust the following option (winblend) if you're using transparent background
        winblend = 0,
        winminwidth = 10,
        winwidth = 30,
        wrap = false,
        wrapscan = true,
        writebackup = false,
    }

    local function isempty(s)
        return s == nil or s == ""
    end
    local function use_if_defined(val, fallback)
        return val ~= nil and val or fallback
    end

    -- custom python provider
    local conda_prefix = os.getenv("CONDA_PREFIX")
    if not isempty(conda_prefix) then
        vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, conda_prefix .. "/bin/python")
        vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, conda_prefix .. "/bin/python")
    else
        vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, "python")
        vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, "python3")
    end

    for name, value in pairs(global_local) do
        vim.api.nvim_set_option_value(name, value, {})
    end

    -- Fix sqlite3 missing-lib issue on Windows
    if global.is_windows then
        -- Download the DLLs form https://www.sqlite.org/download.html

        -- My window sqlite3 dll
        vim.g.sqlite_clib_path = "E:\\xxDownload\\Scoop\\persist\\sqlite\\sqlite3.dll"
    end
end

load_options()
