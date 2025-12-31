vim.notify("init.lua loaded", vim.log.levels.INFO)

-- Suppress deprecation warnings from lspconfig
vim.deprecate = function() end

-- Filter out __GLIBC_USE diagnostics at LSP handler level
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  function(_, result, ctx, config)
    -- Filter diagnostics
    if result and result.diagnostics then
      result.diagnostics = vim.tbl_filter(function(d)
        return not (d.message and d.message:match("__GLIBC_USE"))
      end, result.diagnostics)
    end
    -- Call original handler
    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
  end,
  {}
)

-- ===== Basic options =====
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.scrolloff = 8

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Auto-reload files when changed externally (e.g., by Claude Code)
vim.opt.autoread = true

-- Check for external file changes more frequently
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "checktime",
})

-- Notify when file is reloaded
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File reloaded from disk", vim.log.levels.INFO)
  end,
})

-- ===== Search =====
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- ===== Keymaps =====
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true })
vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true })

-- Markdown preview
vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { silent = true, desc = "Markdown Preview" })
vim.keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { silent = true, desc = "Markdown Preview Stop" })

-- Codeium AI (keybindings work in Insert mode)
-- <Tab>  : Accept suggestion
-- <C-n>  : Next suggestion
-- <C-p>  : Previous suggestion
-- <C-x>  : Clear suggestion

-- ===== Misc =====
vim.opt.clipboard = "unnamedplus"

require("plugins")
