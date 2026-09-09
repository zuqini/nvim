return {
  'mfussenegger/nvim-jdtls',
  cond = not vim.g.vscode,
  ft = 'java',
  config = function()
    -- eclipse.jdt.ls needs Java 21+ to run itself (the projects it indexes can
    -- be older). The `java` on $PATH here is 17, so point the launcher at a
    -- new enough JDK rather than exporting JAVA_HOME globally. Pinned to 21
    -- rather than 21+ because jdtls reuses this JVM for the embedded Gradle
    -- tooling, and the older Gradle wrappers in our repos reject Java 25.
    local jdk = vim.system({ '/usr/libexec/java_home', '-v', '21' }):wait()

    -- Both nvim-lspconfig and nvim-jdtls ship an lsp/jdtls.lua and every match
    -- on the rtp gets deep-merged, so set cmd here to win regardless of order.
    vim.lsp.config('jdtls', {
      -- Overriding cmd drops lspconfig's `-data`, and mason's jdtls wrapper
      -- then falls back to a dir keyed on nvim's cwd basename. Key it on
      -- root_dir instead so a monorepo's import survives across sessions.
      cmd = function(dispatchers, config)
        local data_dir = vim.fs.joinpath(
          vim.fn.stdpath('cache'),
          'jdtls',
          vim.fn.sha256(config.root_dir or assert(vim.uv.cwd()))
        )
        local cmd = { 'jdtls', '-data', data_dir }
        if jdk.code == 0 then
          vim.list_extend(cmd, {
            '--java-executable',
            vim.fs.joinpath(vim.trim(jdk.stdout), 'bin', 'java'),
          })
        end
        return vim.lsp.rpc.start(cmd, dispatchers, {
          cwd = config.cmd_cwd,
          env = config.cmd_env,
          detached = config.detached,
        })
      end,
      settings = {
        java = {
          -- Our repos are Maven; the Gradle syncs only ever fail and each
          -- failure adds seconds to an already slow import.
          import = { gradle = { enabled = false } },
        },
      },
    })
    vim.lsp.enable('jdtls')
  end,
}
