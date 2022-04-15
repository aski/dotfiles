require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true
    }
}

require('nordic').colorscheme {
    underline_option = 'none',
    italic = false,
    italic_comments = false,
    minimal_mode = false,
    alternate_backgrounds = false
}
