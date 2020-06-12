#!/usr/bin/env bash

function update {
    git clone https://github.com/Aryojaam/giTerminal.git giTerminalUpdate
    cd giTerminalUpdate
    cp ./giTerminal.sh ~/giTerminalExecutables/giTerminal
    cp ./updater.sh ~/giTerminalExecutables/
    cp -r ./helpers ~/giTerminalExecutables/
    cd ..
    rm -rf giTerminalUpdate
}

update