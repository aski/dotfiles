return {
   'nvim-lualine/lualine.nvim',
   config = function() 
      require('lualine').setup {
         options = {
            icons_enabled = false,
            theme = 'nord',
            component_separators = '|',
            section_separators = '',
         },
      }
   end
}
