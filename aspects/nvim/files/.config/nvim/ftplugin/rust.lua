local opts = require("config.global").opts
local keymap = require("config.global").keymap

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo[0][0].foldmethod = "expr"

keymap("n", "<Leader>Ld", "<cmd>RustOpenExternalDocs<CR>", opts, "Open Docs")
keymap("n", "<Leader>Ls", "<cmd>RustSSR<CR>", opts, "Structural Search Replace")
keymap("n", "<Leader>Lr", "<cmd>RustRunnables<CR>", opts, "Run Runnables")
keymap("n", "<Leader>LR", "<cmd>RustHoverRange<CR>", opts, "Show Type in hover")
keymap("n", "<Leader>Lh", "<cmd>RustHoverActions<CR>", opts, "Hover Actions")
keymap("n", "<Leader>Lo", "<cmd>RustOpenCargo<CR>", opts, "Open Cargo")
keymap("n", "<Leader>Lp", "<cmd>RustParentModule<CR>", opts, "Parent Module")
keymap("n", "<Leader>Lj", "<cmd>RustJoinLines<CR>", opts, "Join Lines")
keymap("n", "<Leader>Le", "<cmd>RustExpandMacro<CR>", opts, "Expand Macro")
keymap("n", "<Leader>LU", "<cmd>RustMoveItemUp<CR>", opts, "Move Item Up")
keymap("n", "<Leader>LD", "<cmd>RustMoveItemDown<CR>", opts, "Move Item Down")
keymap("n", "<Leader>Lv", "<cmd>RustViewCrateGraph<CR>", opts, "View Crate Graph")
keymap("n", "<Leader>LHe", "<cmd>RustEnableInlayHints<CR>", opts, "Enable Inlay Hints")
keymap("n", "<Leader>LHd", "<cmd>RustDisableInlayHints<CR>", opts, "Disable Inlay Hints")

local dap = require("dap")
local mason_path = vim.fn.glob(vim.fn.stdpath("data")) .. "/mason/"
local codelldb_exec_path = mason_path .. "packages/codelldb/codelldb"

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = codelldb_exec_path,
    args = { "--port", "${port}" },
  },
}

dap.configurations.rust = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    repl_lang = "rust",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
}
