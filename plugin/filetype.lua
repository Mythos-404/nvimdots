vim.filetype.add({
    pattern = {
        [".*/hypr/.*/.*%.conf"] = "hyprlang",
        [".*/hypr/.*%.conf"] = "hyprlang",
        [".env.*"] = "dotenv",

        [".*/.github/workflows/.*%.yml"] = "yaml.ghaction",
        [".*/.github/workflows/.*%.yaml"] = "yaml.ghaction",

        ["Caddyfile"] = "caddy",
    },
    extension = {
        frag = "glsl",
        vert = "glsl",
        mdx = "markdown",
    },
})
vim.treesitter.language.register("bash", "dotenv")
