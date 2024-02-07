-- vim.api.nvim_create_user_command("CopyRelPath", "call setreg('*', expand('%'))", {})
vim.api.nvim_create_user_command("YankParentDirPath",
    function()
        local path = vim.fn.expand("%:p:h")
        vim.fn.setreg("+", path)
        vim.notify('Copied "' .. path .. '" to the clipboard!')
    end, { desc = "Copy path of the parent directory of the current buffer" })
