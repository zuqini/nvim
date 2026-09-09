return {
  'mfussenegger/nvim-jdtls',
  cond = not vim.g.vscode,
  ft = 'java',
  config = function()
    -- eclipse.jdt.ls needs Java 21+ to run itself (the projects it indexes can
    -- be older). The `java` on $PATH here is 17, so point the launcher at a
    -- new enough JDK rather than exporting JAVA_HOME globally.
    local jdk = vim.system({ '/usr/libexec/java_home', '-v', '21+' }):wait()

    -- Both nvim-lspconfig and nvim-jdtls ship an lsp/jdtls.lua and every match
    -- on the rtp gets deep-merged, so set cmd here to win regardless of order.
    vim.lsp.config('jdtls', {
      cmd = jdk.code == 0
          and { 'jdtls', '--java-executable', vim.fs.joinpath(vim.trim(jdk.stdout), 'bin', 'java') }
          or { 'jdtls' },
    })
    vim.lsp.enable('jdtls')
  end,
}
