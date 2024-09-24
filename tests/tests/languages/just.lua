--- This test file run all supported cases of use.
--- @usage :luafile ~/.local/share/nvim/lazy/compiler.nvim/tests/tests/just.lua

local ms = 1000 -- wait time
local language = require("compiler.languages.just")
local example = require("compiler.utils").get_tests_dir("code samples/languages")

coroutine.resume(coroutine.create(function()
  local co = coroutine.running()
  local function sleep()
    vim.defer_fn(function() coroutine.resume(co) end, ms)
    coroutine.yield()
  end

  -- Run justfile
  vim.api.nvim_set_current_dir(example)
  language.action("option1")
  sleep()
end))
