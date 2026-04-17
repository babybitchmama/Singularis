local config = {}

function config.neotest()
  require("neotest").setup({
    adapters = {
      require("neotest-python")({
        dap = { justMyCode = false },
      }),
      require("neotest-plenary"),
      require("neotest-vim-test")({
        ignore_file_types = { "vim", "lua" },
      }),
      require("neotest-jest")({
        jestCommand = "npm test --",
        jestConfigFile = "custom.jest.config.ts",
        env = { CI = true },
        cwd = function(_)
          return vim.fn.getcwd()
        end,
      }),
    },
  })
end

function config.nvim_dap()
  local icons = require("config.global").icons
  local dap = require("dap")
  local dapui = require("dapui")

  local setup = {
    breakpoint = {
      text = icons.ui.Bug,
      texthl = "DiagnosticSignError",
      linehl = "",
      numhl = "",
    },
    breakpoint_rejected = {
      text = icons.ui.Bug,
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = icons.ui.BoldRightArrow,
      texthl = "DiagnosticSignWarn",
      linehl = "Visual",
      numhl = "DiagnosticSignWarn",
    },
    ui = {
      auto_open = true,
    },
  }

  vim.fn.sign_define("DapBreakpoint", setup.breakpoint)
  vim.fn.sign_define("DapBreakpointRejected", setup.breakpoint_rejected)
  vim.fn.sign_define("DapStopped", setup.stopped)

  dapui.setup({
    expand_lines = true,
    icons = { expanded = "", collapsed = "", circular = "" },
    mappings = {
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.33 },
          { id = "breakpoints", size = 0.17 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 0.25 },
        },
        size = 0.33,
        position = "right",
      },
      {
        elements = {
          { id = "repl", size = 0.45 },
          { id = "console", size = 0.55 },
        },
        size = 0.27,
        position = "bottom",
      },
    },
    floating = {
      max_height = 0.9,
      max_width = 0.5,
      border = vim.g.border_chars,
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
end

config.config_paths = { "./.nvim-dap/nvim-dap.lua", "./.nvim-dap.lua", "./.nvim/nvim-dap.lua" }

function config.search_project_config()
  local dap = require("dap")

  local project_config = nil
  for _, p in ipairs(config.config_paths) do
    local f = io.open(p)
    if f then
      f:close()
      project_config = p
      break
    end
  end

  if not project_config then
    return
  end

  vim.notify("[nvim-dap-projects] Found config: " .. project_config)

  -- clear safely
  for k in pairs(dap.adapters) do
    dap.adapters[k] = nil
  end
  for k in pairs(dap.configurations) do
    dap.configurations[k] = nil
  end

  dofile(project_config)
end

return config
