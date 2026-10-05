-- Makefiles have no LazyVim language extra; add their parser directly.
return {
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "make" } } },
}
