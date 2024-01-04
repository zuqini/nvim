":autocmd! pliststrings to disable this
augroup pliststrings
  " Remove all pliststrings autocommands
  autocmd!

  " Output operations
  autocmd BufWriteCmd *.strings call plist#BufWriteCmd()
  autocmd FileWriteCmd *.strings call plist#FileWriteCmd()

  " Input operations
  autocmd BufReadCmd *.strings call plist#BufReadCmd()
  autocmd FileReadCmd *.strings call plist#FileReadCmd()
augroup END
