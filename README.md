## Installation
1. clone giterminal
`git clone https://github.com/Aryojaam/giterminal.git`

2. run the installer by
`cd giterminal && ./installer`

you can now use giterminal by running `giterminal` in your terminal :)

when there are updates you can just simply run `giterminalUpdater` and it should update the program :) Enjoy!

## Development
on linux you need `inotify-tools` to make the development process easier. Install it with `sudo apt-get install inotify-tools`. Then run `./filewatcher.sh` and go wild! `filewatcher.sh` copies the files into your $HOME folder on save so the executables using the commands `giterminal` and `giterminalUpdater` are always up to date. 

If you don't want to use the tool, I would recommend using `./installer` to keep your executable files up to date