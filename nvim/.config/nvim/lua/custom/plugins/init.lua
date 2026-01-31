local hex_mode = false

vim.keymap.set('n', '<leader>hx', function()
  if not hex_mode then
    vim.cmd '%!xxd'
    hex_mode = true
    print 'Hex View Enabled'
  else
    vim.cmd '%!xxd -r'
    hex_mode = false
    print 'Hex View Disabled'
  end
end, { desc = 'Toggle [H]ex View' })

return {
  {
    'nvim-tree/nvim-web-devicons',
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      default = true,
      color_icons = true,
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = { max_lines = 3 },
  },
  {
    'RaafatTurki/hex.nvim',
    config = function()
      require('hex').setup()
    end,
  },
}
