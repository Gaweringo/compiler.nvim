--- just language actions
-- Supporting this filetype allow the user
-- to use the compiler while editing a justfile.

local M = {}

--- Frontend - options displayed on telescope
M.options = {
  { text = "Run justfile", value = "option1" }
}

--- Helper
-- Runs ./justfile in the current working directory.
function M.run_justfile()
  -- If no justfile, show a warning notification and return.
  local stat = vim.loop.fs_stat("./justfile")
  if not stat then
    vim.notify("You must have a justfile in your working directory", vim.log.levels.WARN, {
      title = "Compiler.nvim"
    })
    return
  end

  -- Run justfile
  local utils = require("compiler.utils")
  local overseer = require("overseer")
  local justfile = utils.os_path(vim.fn.getcwd() .. "/justfile", true)
  local final_message = "--task finished--"
  local task = overseer.new_task({
    name = "- just interpreter",
    strategy = { "orchestrator",
      tasks = {{ name = "- Run justfile → " .. justfile,
          cmd = "just -f " .. justfile ..                                    -- run
                " && echo " .. justfile ..                                   -- echo
                " && echo \"" .. final_message .. "\"",
          components = { "default_extended" }
      },},},})
  task:start()
end

--- Backend - overseer tasks performed on option selected
function M.action(selected_option)
  if selected_option == "option1" then
    M.run_justfile()
  end
end

return M
