#!/usr/bin/env bash

mainDirectory=".giterminal"

rcFile=~/".bashrc"
if bash --version | grep -q darwin
then 
   rcFile=~/".zshrc"
fi

mainAlias="alias giterminal='$(pwd)/term.py'"
# updaterAlias="alias giterminalUpdater='~/$mainDirectory/updater'"
aliasFound=$(cat $rcFile | grep giterminal=)
if [ "$aliasFound" == "$mainAlias" ]; then
    # lineNumber=$(grep -n giterminal= ${rcFile} | cut -d : -f 1)
    # sed -i `${lineNumber}s/.*/"${mainAlias}"/` $rcFile
    echo "Alias already there"
else
    echo $mainAlias >> $rcFile
    echo "giterminal installed successfully"
    exec bash
fi