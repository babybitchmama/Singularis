local treesitter = function()
  local has_ts = pcall(require, "nvim-treesitter")
  if not has_ts then
    vim.notify("ts not installed")
    return
  end

  local parsers = {
    "python",
    "cpp",
    "c",
    -- "cs",
    "sql",
    "html",
    "css",
    "javascript",
    "typescript",
    "php",
    "ruby",
    "perl",
    "java",
    "rust",
    "solidity",
    "dockerfile",
    "kotlin",
    "ocaml",
    "zig",
    "markdown",
  }
  require("nvim-treesitter").install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- check if parser exists and load it
    if not vim.treesitter.language.add(language) then
      return
    end
    -- enables syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- enables treesitter based folds
    -- for more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

    -- enables treesitter based indentation
    if has_indent_query then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end

  local available_parsers = require("nvim-treesitter").get_available()
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then
        return
      end

      local installed_parsers = require("nvim-treesitter").get_installed("parsers")

      if vim.tbl_contains(installed_parsers, language) then
        -- enable the parser if it is installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
        require("nvim-treesitter").install(language):await(function()
          treesitter_try_attach(buf, language)
        end)
      else
        -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

local treesitter_obj = function()
  local lines = vim.fn.line("$")
  if lines > 8000 then
    print("skip treesitter obj")
    return
  end
end

local treesitter_ref = function()
  require("nvim-treesitter").setup({
    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = false },
      smart_rename = { enable = false },
      navigation = { enable = false },
    },
    matchup = {
      enable = true,
      disable_virtual_text = true,
    },
    autopairs = { enable = true },
    autotag = { enable = false },
  })

  vim.g.matchup_matchparen_enabled = 0
end

local function textsubjects()
  -- require("nvim-treesitter-textobjects").setup({
  --   select = {
  --     enable = true,
  --     lookahead = true,
  --     keymaps = {
  --       ["af"] = "@function.outer",
  --       ["if"] = "@function.inner",

  --       ["ac"] = "@class.outer",
  --       ["ic"] = "@class.inner",

  --       ["as"] = { query = "@scope", query_group = "locals" },
  --     },

  --     selection_modes = {
  --       ["@parameter.outer"] = "v",
  --       ["@function.outer"] = "V",
  --       ["@function.inner"] = "v",
  --       ["@class.outer"] = "<c-v>",
  --     },

  --     include_surrounding_whitespace = true,
  --   },

  --   swap = {
  --     enable = true,
  --     swap_next = { ["[n"] = "@parameter.inner" },
  --     swap_previous = { ["]n"] = "@parameter.inner" },
  --   },

  --   move = {
  --     enable = true,
  --     set_jumps = true,
  --     goto_next_start = {
  --       ["]m"] = "@function.outer",
  --       ["]]"] = "@class.outer",
  --     },
  --     goto_next_end = {
  --       ["]M"] = "@function.outer",
  --       ["]["] = "@class.outer",
  --     },
  --     goto_previous_start = {
  --       ["[m"] = "@function.outer",
  --       ["[["] = "@class.outer",
  --     },
  --     goto_previous_end = {
  --       ["[M"] = "@function.outer",
  --       ["[]"] = "@class.outer",
  --     },
  --   },
  -- })
end

local function tshopper() end

local treesitter_context = function(width)
  local ok, ts = pcall(require, "nvim-treesitter")
  if not ok or not ts then
    return " "
  end
  local en_context = true

  local type_patterns = {
    "class",
    "function",
    "method",
    "interface",
    "type_spec",
    "table",
    "if_statement",
    "for_statement",
    "for_in_statement",
    "call_expression",
    "comment",
  }

  if vim.o.ft == "json" then
    type_patterns = { "object", "pair" }
  end
  if not en_context then
    return " "
  end

  local f = require("nvim-treesitter").statusline({
    indicator_size = width,
    type_patterns = type_patterns,
  })
  local context = string.format("%s", f)

  if context == "vim.NIL" then
    return " "
  end

  return " " .. context
end
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("SyntaxFtAuGroup", {}),
  callback = function()
    local fsize = vim.fn.getfsize(vim.fn.expand("%:p:f")) or 1
    if fsize < 100000 then
      vim.cmd("syntax on")
    end
  end,
})

return {
  treesitter = treesitter,
  treesitter_obj = treesitter_obj,
  treesitter_ref = treesitter_ref,
  textsubjects = textsubjects,
  context = treesitter_context,
  tshopper = tshopper,
}
