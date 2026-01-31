return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Set the header (The ASCII art part)
    dashboard.section.header.val = {
      '                                ',
      '  ███╗   ██╗██╗   ██╗██╗███╗   ███╗ ',
      '  ████╗  ██║██║   ██║██║████╗ ████║ ',
      '  ██╔██╗ ██║██║   ██║██║██╔████╔██║ ',
      '  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
      '  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
      '  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
      '                                ',
    }

    -- THIS IS THE DAY/DATE LOGIC
    local datetime = os.date '  %A, %B %d' -- Example: Thursday, January 29
    dashboard.section.footer.val = datetime
    dashboard.section.footer.opts.hl = 'Constant'

    -- Menu buttons
    dashboard.section.buttons.val = {
      dashboard.button('n', '  New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('f', '󰈞  Find file', ':Telescope find_files<CR>'),
      dashboard.button('g', '󰊄  Live grep', ':Telescope live_grep<CR>'),
      dashboard.button('c', '  Configuration', ':e $MYVIMRC <CR>'),
      dashboard.button('q', '󰅚  Quit', ':qa<CR>'),
    }

    alpha.setup(dashboard.opts)
  end,
}
