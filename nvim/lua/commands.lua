local utils = require('utils')

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

-- function to cd into the git root directory
vim.api.nvim_create_user_command('CdGitRoot', function()
    local git_root = utils.get_git_root()
    if git_root then
        vim.cmd('cd ' .. git_root)
    else
        vim.notify('Not in a git repository', 'error')
    end
end, { desc = 'Change directory to the root of the git repository' })


-- function to trim trailing whitespace
vim.cmd([[
  command! TrimWhitespace lua TrimWhitespace()
]])
function TrimWhitespace()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
end
