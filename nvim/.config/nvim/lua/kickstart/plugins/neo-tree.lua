return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  -- 1. RESTORE YOUR KEYBINDS
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    -- 2. FORCE ICONS TO RENDER
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '󰜌',
        default = '󰈚',
        highlight = 'NeoTreeFileIcon',
      },
    },
    renderers = {
      file = {
        { 'indent' },
        { 'icon' }, -- This component pulls from nvim-web-devicons automatically
        { 'name', use_git_status_colors = true },
        { 'bufnr' },
        { 'git_status' },
      },
    },
    filesystem = {
      -- This makes sure Neo-tree doesn't hide stuff you want to see
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
