## Installation
1. clone giTerminal
`git clone https://github.com/Aryojaam/giTerminal.git`

2. run the installer by
`cd giTerminal && ./installer`

you can now use giTerminal by running `giTerminal` in your terminal :)

when there are updates you can just simply run `giTerminalUpdater` and it should update the program :) Enjoy!

## Development
on linux you need `inotify-tools` to make the development process easier. Install it with `sudo apt-get install inotify-tools`. Then run `./filewatcher.sh` and go wild! `filewatcher.sh` copies the files into your $HOME folder on save so the executables using the commands `giTerminal` and `giTerminalUpdater` are always up to date. 

If you don't want to use the tool, I would recommend using `./install` to keep your executable giTerminal up to date