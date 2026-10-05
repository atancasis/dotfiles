-- Keep deletes and changes out of the macOS clipboard; yanks are copied to it
-- by the autocmd in autocmds.lua.
vim.opt.clipboard = ""
