#!/usr/bin/env bash

# sudo cp ./giTerminal.sh /usr/local/bin/giTerminal #I don't like using sudo
# sudo cp -r ./helpers/ /usr/local/bin/ 

function copyFiles {
    cp ./giTerminal.sh ~/giTerminalExecutables/giTerminal
    cp ./updater.sh ~/giTerminalExecutables/updater
    cp -r ./helpers ~/giTerminalExecutables/
}

rcFile=~/".bashrc"
if bash --version | grep -q darwin
then 
   rcFile=~/".bash_profile"
fi

mainAlias="alias giTerminal='~/giTerminalExecutables/giTerminal'"
updaterAlias="alias giTerminalUpdater='~/giTerminalExecutables/updater'"
aliasFound=$(cat $rcFile | grep giTerminal=)

if [ "$aliasFound" == "$mainAlias" ]; then
    echo "Updating from local files. For a repo update, use giTerminalUpdater command"
    copyFiles
else
    echo $mainAlias >> $rcFile
    echo $updaterAlias >> $rcFile
    mkdir ~/giTerminal
    copyFiles
    echo "giTerminal installed successfully"
    exec bash
fi