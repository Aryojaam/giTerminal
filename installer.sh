#!/usr/bin/env bash

# sudo cp ./giTerminal.sh /usr/local/bin/giTerminal #I don't like using sudo
# sudo cp -r ./helpers/ /usr/local/bin/ 

function copyFiles {
    cp ./giTerminal.sh ~/giTerminal/giTerminal
    cp ./updater.sh ~/giTerminal/updater
    cp -r ./helpers ~/giTerminal/
}

rcFile=~/".bashrc"
if bash --version | grep -q darwin
then 
   rcFile=~/".bash_profile"
fi

mainAlias="alias giTerminal='~/giTerminal/giTerminal'"
updaterAlias="alias giTerminalUpdater='~/giTerminal/updater'"
aliasFound=$(cat $rcFile | grep giTerminal=)

if [ "$aliasFound" == "$mainAlias" ]; then
    echo "Updating from local files. For a repo update, use giTerminalUpdater command"
    copyFiles
else
    echo $mainAlias >> $rcFile
    echo $updaterAlias >> $rcFile
    echo $
    mkdir ~/giTerminal
    copyFiles
    source $rcFile
    echo "giTerminal installed successfully"
fi