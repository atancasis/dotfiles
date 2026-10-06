-- Run Vitest and Playwright tests from Neovim.
return {
  {
    "nvim-neotest/neotest",
    dependencies = { "marilari88/neotest-vitest", "thenbe/neotest-playwright" },
    opts = {
      adapters = {
        "neotest-vitest",
        -- The module wraps its adapter; LazyVim unwraps it only when given a config.
        ["neotest-playwright"] = { options = {} },
      },
    },
  },
}
