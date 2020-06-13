#!/usr/bin/env bash

# sudo cp ./giterminal.sh /usr/local/bin/giterminal #I don't like using sudo
# sudo cp -r ./helpers/ /usr/local/bin/ 
mainDirectory=".giterminal"

function copyFiles {
    cp ./giterminal.sh ~/$mainDirectory/
    mv ~/$mainDirectory/giterminal.sh ~/$mainDirectory/giterminal
    cp ./updater.sh ~/$mainDirectory/
    mv ~/$mainDirectory/updater.sh ~/$mainDirectory/updater
    cp -r ./helpers ~/$mainDirectory/
}

rcFile=~/".bashrc"
if bash --version | grep -q darwin
then 
   rcFile=~/".bash_profile"
fi

mainAlias="alias giterminal='~/$mainDirectory/giterminal'"
updaterAlias="alias giterminalUpdater='~/$mainDirectory/updater'"
aliasFound=$(cat $rcFile | grep giterminal=)

if [ "$aliasFound" == "$mainAlias" ]; then
    echo "Updating from local files. For a repo update, use giterminalUpdater command"
    copyFiles
else
    echo $mainAlias >> $rcFile
    echo $updaterAlias >> $rcFile
    mkdir ~/.giterminal
    copyFiles
    echo "giterminal installed successfully"
    exec bash
fi