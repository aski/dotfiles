return {
   'shaunsingh/nord.nvim',
   priority = 1002,
   config = function()
      -- Configure and set colorscheme
      vim.g.nord_italic = false
      vim.g.nord_bold = false
      require('nord').set()
   end
}
