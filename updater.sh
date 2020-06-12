#!/usr/bin/env bash

function update {
    git clone https://github.com/Aryojaam/giTerminal.git giTerminalUpdate
    cd giTerminalUpdate
    cp ./giTerminal.sh ~/giTerminal/
    mv ~/giTerminal/giTerminal.sh ~/giTerminal/giTerminal
    cp ./updater.sh ~/giTerminal/
    cp -r ./helpers ~/giTerminal/
    cd ..
    rm -rf giTerminalUpdate
}

update