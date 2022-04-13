require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    }
}

require('nordic').colorscheme({
    underline_option = 'none',
    italic = false,
    italic_comments = true,
    minimal_mode = false,
    alternate_backgrounds = false
})
