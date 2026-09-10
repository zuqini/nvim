-- jdtls keys its workspace on root_dir, and indexing this monorepo costs ~20
-- minutes and ~3GB. There are ~60 throwaway task worktrees under ~/workspace,
-- so autostarting anywhere would earn each one its own index on the first
-- .java file opened -- and deleting the worktree orphans that index under a
-- hash of a path that no longer exists. Pin autostart to the four long-lived
-- checkouts instead; review worktrees get no Java LSP, which is the right
-- trade for reading code.
local roots = {}
for _, name in ipairs({ 'A', 'B', 'C', 'D' }) do
  roots[#roots + 1] = vim.fs.normalize('~/jingle/' .. name)
end

local cache = vim.fs.joinpath(vim.fn.stdpath('cache'), 'jdtls')

-- jdtls reports import progress over `language/status`, a non-standard
-- notification nvim has no handler for, so it only ever reached the log. Keep
-- the last one; a single import emitted 5,632 of these, so notifying on each
-- is not an option.
local status = 'not started'

return {
  'mfussenegger/nvim-jdtls',
  cond = not vim.g.vscode,
  ft = 'java',

  -- In `init` rather than `config` so pruning doesn't require opening a Java
  -- file first -- the point is to reclaim space for checkouts you've deleted.
  init = function()
    vim.api.nvim_create_user_command('JdtlsPrune', function()
      -- Autostart is pinned to `roots`, so those four hashes are the only
      -- legitimate workspaces and anything else is a leftover. That also
      -- means a live server is never in scope, so nothing needs stopping.
      local keep = {}
      for _, root in ipairs(roots) do
        keep[vim.fn.sha256(root)] = true
      end

      for name, kind in vim.fs.dir(cache) do
        if kind == 'directory' and not keep[name] then
          vim.fs.rm(vim.fs.joinpath(cache, name), { recursive = true, force = true })
        end
      end
    end, { desc = 'Remove orphaned jdtls workspaces' })

    vim.api.nvim_create_user_command('JdtlsStatus', function()
      vim.notify(vim.trim(('jdtls: %s\n%s'):format(status, vim.lsp.status())))
    end, { desc = 'Show jdtls import progress' })
  end,

  config = function()
    -- eclipse.jdt.ls needs Java 21+ to run itself (the projects it indexes can
    -- be older). The `java` on $PATH here is 17, so point the launcher at a
    -- new enough JDK rather than exporting JAVA_HOME globally. Pinned to 21
    -- rather than 21+ because jdtls reuses this JVM for the embedded Gradle
    -- tooling, and the older Gradle wrappers in our repos reject Java 25.
    local jdk = vim.system({ '/usr/libexec/java_home', '-v', '21' }):wait()

    local gradle_off = { java = { import = { gradle = { enabled = false } } } }

    -- Both nvim-lspconfig and nvim-jdtls ship an lsp/jdtls.lua and every match
    -- on the rtp gets deep-merged, so set cmd here to win regardless of order.
    vim.lsp.config('jdtls', {
      -- Overriding cmd drops lspconfig's `-data`, and mason's jdtls wrapper
      -- then falls back to a dir keyed on nvim's cwd basename. Key it on
      -- root_dir instead so a monorepo's import survives across sessions.
      cmd = function(dispatchers, config)
        local root = config.root_dir or assert(vim.uv.cwd())
        local cmd = { 'jdtls', '-data', vim.fs.joinpath(cache, vim.fn.sha256(root)) }
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

      -- Match on the buffer path rather than lspconfig's marker search: every
      -- worktree has a .git, so marker detection would happily root a review
      -- worktree. Not calling on_dir leaves the client unstarted.
      root_dir = function(bufnr, on_dir)
        local file = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
        for _, root in ipairs(roots) do
          if vim.startswith(file, root .. '/') then
            return on_dir(root)
          end
        end
      end,

      -- Our repos are Maven; the Gradle syncs only ever fail and each failure
      -- adds seconds to an already slow import. `settings` alone is too late:
      -- it ships in didChangeConfiguration, by which point the initial import
      -- has already given the nested Gradle builds a Gradle nature that
      -- Buildship then resyncs forever. init_options is read during
      -- initialize, so send it in both places.
      init_options = { settings = gradle_off },
      settings = gradle_off,

      handlers = {
        ['language/status'] = function(_, result)
          status = ('%s - %s'):format(result.type, result.message)
        end,
      },
    })
    vim.lsp.enable('jdtls')
  end,
}
