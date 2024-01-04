" For Teensy support
" https://forum.pjrc.com/threads/53548-Arduino-CLI-Alpha-Release-Teensy-Support?p=299430&viewfull=1#post299430
" 1. Install arduino-cli
" 2. arduino-cli config init
" 3. Go to config file and add https://www.pjrc.com/teensy/package_teensy_index.json in "Additional boards manager URLs" to additional_urls (https://www.pjrc.com/teensy/td_download.html)
" 4. arduino-cli core search teensy to find package
" 5. arduino-cli core install teensy:avr
"
" Change these as desired
nnoremap <buffer> <leader>aa <cmd>ArduinoAttach<CR>
nnoremap <buffer> <leader>am <cmd>ArduinoVerify<CR>
nnoremap <buffer> <leader>au <cmd>ArduinoUpload<CR>

" you have to kill the screen session using it's escape key. By default this is bound to <C-a><C-k>
" note exiting screen session from vim doesn't seem to work in tmux
nnoremap <buffer> <leader>ad <cmd>ArduinoUploadAndSerial<CR>
nnoremap <buffer> <leader>as <cmd>ArduinoSerial<CR>

nnoremap <buffer> <leader>ab <cmd>ArduinoChooseBoard<CR>
nnoremap <buffer> <leader>ap <cmd>ArduinoChooseProgrammer<CR>
