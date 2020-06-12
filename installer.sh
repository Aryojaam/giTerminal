#!/usr/bin/env bash

# sudo cp ./giTerminal.sh /usr/local/bin/giTerminal #I don't like using sudo
# sudo cp -r ./helpers/ /usr/local/bin/ 
mainDirectory="giTerminalExecutables"

function copyFiles {
    cp ./giTerminal.sh ~/$mainDirectory/
    mv ~/$mainDirectory/giTerminal.sh ~/$mainDirectory/giTerminal
    cp ./updater.sh ~/$mainDirectory/
    mv ~/$mainDirectory/updater.sh ~/$mainDirectory/updater
    cp -r ./helpers ~/$mainDirectory/
}

rcFile=~/".bashrc"
if bash --version | grep -q darwin
then 
   rcFile=~/".bash_profile"
fi

mainAlias="alias giTerminal='~/$mainDirectory/giTerminal'"
updaterAlias="alias giTerminalUpdater='~/$mainDirectory/updater'"
aliasFound=$(cat $rcFile | grep giTerminal=)

if [ "$aliasFound" == "$mainAlias" ]; then
    echo "Updating from local files. For a repo update, use giTerminalUpdater command"
    copyFiles
else
    echo $mainAlias >> $rcFile
    echo $updaterAlias >> $rcFile
    mkdir ~/giTerminalExecutables
    copyFiles
    echo "giTerminal installed successfully"
    exec bash
fi