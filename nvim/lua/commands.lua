-- vim.api.nvim_create_user_command("CopyRelPath", "call setreg('*', expand('%'))", {})
vim.api.nvim_create_user_command("YankParentDirPath",
    function()
        local path = vim.fn.expand("%:p:h")
        vim.fn.setreg("+", path)
        vim.notify('Copied "' .. path .. '" to the clipboard!')
    end, { desc = "Copy path of the parent directory of the current buffer" })

-- function to validate a jenkinsfile
-- requires JENKINS_HOST and JENKINS_AUTH (user_id:api_token) to be set as env vars
vim.api.nvim_create_user_command('ValidateJenkinsFile', function()
    local buf = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(buf)
    local curl_cmd = string.format(
        'curl -s -X POST --user "$JENKINS_AUTH" -F "jenkinsfile=<%s" "$JENKINS_URL/pipeline-model-converter/validate"',
        filename)
    local result = vim.fn.system(curl_cmd)
    print(result)
end, { desc = 'Validate jenkinsfile' })
