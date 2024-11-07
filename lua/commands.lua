function ClearReg()
  print('Clearing registers')
  vim.cmd [[
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
    call setreg(r, [])
    endfor
]]
end

vim.api.nvim_create_user_command('ClearReg', function()
  ClearReg()
end, {})

-- tabs
vim.api.nvim_create_user_command('TS', "tab split", { bang = true })
vim.api.nvim_create_user_command('TB', "tab new", { bang = true })
vim.api.nvim_create_user_command('VS', "vs", { bang = true })
vim.api.nvim_create_user_command('SP', "sp", { bang = true })
