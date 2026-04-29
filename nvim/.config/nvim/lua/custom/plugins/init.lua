-- Options
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Keymaps
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

-- Telescope
vim.keymap.set('n', '<leader>pf', function()
  require('telescope.builtin').find_files { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Find files in current buffer directory' })

vim.keymap.set('n', '<leader>pg', function()
  require('telescope.builtin').live_grep { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Grep in current buffer directory' })

-- Tree-sitter
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
---@diagnostic disable-next-line: inject-field
parser_config.nytrogen = {
  install_info = {
    url = '~/dev/tree-sitter-nytrogen',
    files = { 'src/parser.c' },
    branch = 'main',
  },
  filetype = 'ny',
}

-- Plugins
return {
  {
    'nvim-tree/nvim-web-devicons',
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      local devicons = require 'nvim-web-devicons'
      devicons.setup {
        default = true,
        color_icons = true,
      }

      -- Nytrogen icon
      devicons.set_icon {
        ny = {
          icon = '󰙒', -- random cool thing
          color = '#4287f5',
          name = 'Nytrogen',
        },
        nyt = { -- nyt cuz why not
          icon = '󰙒',
          color = '#4287f5',
          name = 'Nytrogen',
        },
      }
    end,
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
