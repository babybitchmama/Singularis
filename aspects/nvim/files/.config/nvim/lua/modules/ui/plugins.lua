if vim.g.isInkscape then
  return function(_use) end
end

local latexPlugins = {
  "echasnovski/mini.hues",
  config = function()
    -- require("mini.hues").setup({ background = "#090610", foreground = "#acc2d2", saturation = "high", n_hues = 6 })
    -- require("mini.hues").setup({ background = "#0E0814", foreground = "#cfd9dc", saturation = "high", n_hues = 6
    -- require("mini.hues").setup({ background = "#0f0c22", foreground = "#7cdeec", saturation = "high", n_hues = 6 })
    -- require("mini.hues").setup({ background = "#151823", foreground = "#a9b9dc", saturation = "high", n_hues = 6 })
    -- require("mini.hues").setup({ background = "#121c2d", foreground = "#cbdde8", saturation = "high", n_hues = 6 })
    require("mini.hues").setup({ background = "#15171a", foreground = "#dcc7c2", saturation = "high", n_hues = 6 })
  end,
  lazy = false,
  -- {
  --   "echasnovski/mini.hues",
  --   config = function()
  --     -- require("mini.hues").setup({ background = "#090610", foreground = "#acc2d2", saturation = "high", n_hues = 6 })
  --     -- require("mini.hues").setup({ background = "#0E0814", foreground = "#cfd9dc", saturation = "high", n_hues = 6
  --     require("mini.hues").setup({ background = "#0f0c22", foreground = "#7cdeec", saturation = "high", n_hues = 6 })
  --   end,
  --   lazy = false,
  -- },
  -- {
  --   "folke/which-key.nvim",
  --   config = function()
  --     require("modules.ui.which-key")
  --   end,
  --   event = "BufEnter",
  -- },
}

if vim.g.isLATEX then
  return function(use)
    use(latexPlugins)
    use({ "windwp/windline.nvim" })
  end
end

local conf = require("modules.ui.config")

return function(use)
  use(latexPlugins)

  use({ "nvim-tree/nvim-web-devicons" })

  use({ "MunifTanjim/nui.nvim" })

  use({ "lambdalisue/glyph-palette.vim" })

  use({
    "stevearc/dressing.nvim",
    init = function()
      conf.dressing_init()
    end,
  })

  -- use({
  --   "lukas-reineke/indent-blankline.nvim",
  --   event = { "BufReadPost", "BufNewFile" },
  --   version = "2.20.8",
  --   opts = {
  --     char = "▏",
  --     context_char = "▏",
  --     show_end_of_line = false,
  --     space_char_blankline = " ",
  --     show_current_context = true,
  --     show_current_context_start = true,
  --     filetype_exclude = {
  --       "help",
  --       "startify",
  --       "dashboard",
  --       "packer",
  --       "neogitstatus",
  --       "NvimTree",
  --       "Trouble",
  --       "alpha",
  --       "neo-tree",
  --     },
  --     buftype_exclude = {
  --       "terminal",
  --       "nofile",
  --     },
  --   },
  -- })

  use({ "windwp/windline.nvim" })
  use({
    "kevinhwang91/nvim-hlslens",
    config = conf.hlslens,
    keys = {
      "n",
      "N",
      "*",
      "#",
      "g*",
      "g#",
    },
  })

  -- use({
  --   "kevinhwang91/nvim-ufo",
  --   dependencies = { "kevinhwang91/promise-async" },
  --   opts = {
  --     provider_selector = function(bufnr, filetype, buftype)
  --       return { "treesitter", "indent" }
  --     end,
  --   },
  --   config = function(_, opts)
  --     local ufo = require("ufo")

  --     ufo.setup(opts)

  --     vim.keymap.set("n", "zR", ufo.openAllFolds)
  --     vim.keymap.set("n", "zM", ufo.closeAllFolds)
  --     vim.keymap.set("n", "K", function()
  --       local winid = ufo.peekFoldedLinesUnderCursor(true)
  --       if not winid then
  --         vim.lsp.buf.hover()
  --       end
  --     end, { desc = "LSP: Show hover documentation and folded code" })
  --   end,
  -- })

  use({
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require("pretty-fold").setup({
        sections = {
          left = {
            'content',
          },
          right = {
            ' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
            function(config) return config.fill_char:rep(3) end
          }
        },
        fill_char = '•',

        remove_fold_markers = true,

        -- Keep the indentation of the content of the fold string.
        keep_indentation = true,

        -- Possible values:
        -- "delete" : Delete all comment signs from the fold string.
        -- "spaces" : Replace all comment signs with equal number of spaces.
        -- false    : Do nothing with comment signs.
        process_comment_signs = 'spaces',

        -- Comment signs additional to the value of `&commentstring` option.
        comment_signs = {},

        -- List of patterns that will be removed from content foldtext section.
        stop_words = {
          '@brief%s*', -- (for C++) Remove '@brief' and all spaces after.
        },

        add_close_pattern = true, -- true, 'last_line' or false

        matchup_patterns = {
          {  '{', '}' },
          { '%(', ')' }, -- % to escape lua pattern char
          { '%[', ']' }, -- % to escape lua pattern char
        },

        ft_ignore = { 'neorg' },
        }
      )
    end,
    filetype = {
      "lua",
      "python",
      "javascript",
      "typescript",
      "rust",
      "go",
      "java",
      "c",
      "cpp",
      "html",
      "css",
      "json",
    },
  })

  use({
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        sass = { enable = true, parsers = { "css" } },
        virtualtext = "■",
        always_update = true,
      },
    },
  })
end
