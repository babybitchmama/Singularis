local lsp = {}

lsp.setup_codelens_refresh = function(client, bufnr)
  local status_ok, codelens_supported = pcall(function()
    return client.supports_method("textDocument/codeLens")
  end)

  if not status_ok or not codelens_supported then
    return
  end

  local group = "lsp_code_lens_refresh"
  local cl_events = { "BufEnter", "InsertLeave" }
  local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = group,
    buffer = bufnr,
    event = cl_events,
  })

  if ok and #cl_autocmds > 0 then
    return
  end
  vim.api.nvim_create_augroup(group, { clear = false })
  vim.api.nvim_create_autocmd(cl_events, {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
  })
end

lsp.attach_mappings = function(_, bufnr)
  vim.keymap.set("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>", { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lE", "<CMD>Telescope diagnostics<CR>", { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lr", function()
    vim.lsp.bu.format({ async = true })
  end, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>li", vim.cmd.LspInfo, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lo", vim.cmd.OutlineOpen, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lD", "<CMD>Namu symbols<CR>", { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>ldp", function()
    require("nvim-treesitter.textobjects.lsp_interop").peek_definition_code(
      "@function.outer",
      nil,
      "textDocument/typeDefinition"
    )
  end, { buffer = true, silent = true })

  vim.keymap.set("n", "<leader>ldd", vim.lsp.buf.definition, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>ldr", vim.lsp.buf.references, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>ldt", vim.lsp.buf.type_definition, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>ldi", vim.lsp.buf.implementation, { buffer = true, silent = true })

  vim.keymap.set("n", "<leader>lqa", vim.diagnostic.setloclist, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lql", vim.diagnostic.setqflist, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>lwl", vim.lsp.buf.list_workspace_folders, { buffer = true, silent = true })
end

lsp.on_attach = function(client, bufnr)
  lsp.attach_mappings(client, bufnr)

  -- if client.name == "jdtls" then
  --   require("jdtls").setup_dap({ hotcodereplace = "auto" })
  --   require("jdtls.dap").setup_dap_main_class_configs()

  --   vim.lsp.codelens.refresh()
  -- elseif client.name == "clangd" then
  --   require("modules.lsp.filetypes.cpp").clangd_extensions()
  -- end

  require("inlay-hints").on_attach(client, bufnr)
  if vim.bo.filetype ~= "TelescopePrompt" then
    lsp.setup_codelens_refresh(client, bufnr)
  end

  -- if client.name == "sqls" then
  --   require("sqls").on_attach(client, bufnr)
  -- elseif client.name == "gopls" then
  --   if not client.server_capabilities.semanticTokensProvider then
  --     local semantic = client.config.capabilities.textDocument.semanticTokens
  --     client.server_capabilities.semanticTokensProvider = {
  --       full = true,
  --       legend = {
  --         tokenTypes = semantic.tokenTypes,
  --         tokenModifiers = semantic.tokenModifiers,
  --       },
  --       range = true,
  --     }
  --   end
  -- elseif client.name == "yamlls" then
  --   client.server_capabilities.textDocument.foldingRange = {
  --     dynamicRegistration = false,
  --     lineFoldingOnly = false,
  --   }
  -- end

  require("colorizer").attach_to_buffer(bufnr)

  -- client.config.capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- client.config.capabilities.textDocument.foldingRange = {
  --   dynamicRegistration = false,
  --   lineFoldingOnly = true,
  -- }

  -- lsp.capabilities = client.config.capabilities
end

return lsp
