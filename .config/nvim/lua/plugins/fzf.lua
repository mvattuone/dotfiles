local function configure_fzf_lua()
  local fzf = require("fzf-lua")

  fzf.setup({
    grep = {
      rg_opts = table.concat({
        "--vimgrep",
        "--multiline",
        "--multiline-dotall",  -- allow `.` to match newlines
        "--color=always",
        "--line-number",
        "--no-heading",
        "--column",
        "--hidden",
        "--smart-case",
        "--pcre2",
        "--glob=!.git/",
      }, " "),
    },
  })

  vim.keymap.set("n", "<leader>;", function()
    fzf.buffers()
  end, { desc = "FZF Buffers" })

  vim.keymap.set("n", "<C-p>", function()
    fzf.files()
  end, { desc = "FZF Files" })

  vim.keymap.set("n", "<leader>t", function()
    fzf.tags()
  end, { desc = "FZF Tags" })

  vim.keymap.set("n", "<leader>/", function()
    local pattern = vim.fn.input("Rg> ")
    if pattern ~= "" then
      fzf.live_grep({ search = pattern, no_esc = true })
    end
  end, { desc = "FZF Ripgrep" })

  vim.keymap.set("x", "<leader>/", function()
    vim.cmd('normal! y')
    local text = vim.fn.getreg('"')
    fzf.grep({ search = text })
  end, { desc = "FZF Ripgrep visual selection" })

  vim.keymap.set("n", "<leader>\\", function()
    fzf.buffers({
      header = "Press enter on selected buffer to close",
      fzf_opts = {
        ["--multi"]  = true,
        ["--layout"] = "reverse",
        ["--bind"]   = table.concat({
          "up:up",
          "down:down",
          "left:ignore",
          "right:ignore",
          "ctrl-a:toggle-all+accept",
          "ctrl-x:ignore",
        }, ","),
      },
      actions = {
        default = function(selected)
          for _, line in ipairs(selected) do
            local bufnr = tonumber(line:match("^%s*%[(%d+)%]"))
            if bufnr then vim.api.nvim_buf_delete(bufnr, { force = true }) end
          end
        end,
      },
    })
  end, { desc = "Delete Buffers" })
end

return {
  {
    "junegunn/fzf",
    build = "./install --bin",
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "junegunn/fzf", "nvim-lua/plenary.nvim" },
    config = configure_fzf_lua,
  },
}
