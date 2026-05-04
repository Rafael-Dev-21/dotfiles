-- ~/.config/nvim/init.lua

-- ============================================================================
-- Basic options
-- ============================================================================
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Syntax & filetype
vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

-- ============================================================================
-- Plugin manager: lazy.nvim
-- ============================================================================
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Your existing plugins (no coc.nvim)
  { 'kovisoft/slimv' },                     -- Common Lisp REPL
  {
    'preservim/vim-pencil',
    config = function()
      vim.g['pencil#wrapModeDefault'] = 'soft'
    end,
  },
  {
    'vim-airline/vim-airline',
    config = function()
      vim.g.airline_section_x = '%{PencilMode()}'
    end,
  },

  -- ==========================================================================
  -- Modern Language Server Protocol (LSP) stack
  -- ==========================================================================
  -- Mason: install LSP servers, DAP, linters, formatters
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    config = function()
      require('mason').setup()
    end,
  },

  -- Bridge between Mason and lspconfig
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'lua_ls', 'pyright', 'ts_ls', 'clangd' }, -- add your servers
        automatic_installation = true,
      })
    end,
  },

  -- LSP configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    config = function()
      local lspconfig = require('lspconfig')
      -- Optional: keymaps and capabilities for completion
      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
      end

      -- Setup each server; mason-lspconfig will automatically configure
      -- the ones that are installed. We just define the default handler.
      require('mason-lspconfig').setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
          })
        end,
      })
    end,
  },
--[[
  -- Autocompletion engine
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',      -- LSP source
      'hrsh7th/cmp-buffer',        -- buffer words
      'hrsh7th/cmp-path',          -- file system paths
      'L3MON4D3/LuaSnip',          -- snippet engine
      'saadparwaiz1/cmp_luasnip',  -- snippet source
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },
  ]]--

  -- Optional: better UI for LSP diagnostics (like trouble.nvim or lsp_lines)
  -- But not strictly required. You can add:
  -- { 'folke/trouble.nvim', opts = {} },
})

-- ============================================================================
-- Colorscheme
-- ============================================================================
vim.cmd.colorscheme('default')

