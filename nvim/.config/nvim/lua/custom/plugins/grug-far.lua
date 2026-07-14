return {
  'MagicDuck/grug-far.nvim',
  config = function()
    require('grug-far').setup {}
  end,
  keys = {
    { '<leader>fr', '<cmd>GrugFar<cr>', desc = 'Search and Replace (Grug)' },
  },
}
