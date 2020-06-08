#!/usr/bin/env bash

# sudo cp ./giTerminal.sh /usr/local/bin/giTerminal #I don't like using sudo
# sudo cp -r ./helpers/ /usr/local/bin/ 

function copyFiles {
    cp ./giTerminal.sh ~/giTerminal/giTerminal
    cp -r ./helpers ~/giTerminal/
}

rcFile=~/".bashrc"
if bash --version | grep -q darwin
then 
   rcFile=~/".bash_profile"
fi

aliasString="alias giTerminal='~/giTerminal/giTerminal'"
aliasFound=$(cat $rcFile | grep giTerminal)

if [ "$aliasFound" == "$aliasString" ]; then
    echo "Updating"
    copyFiles
else
    echo $aliasString >> ~/.bashrc
    mkdir ~/giTerminal
    copyFiles
    exec bash
    echo "giTerminal installed successfully"
fi