#!/usr/bin/env bash

function update {
    git clone https://github.com/Aryojaam/giTerminal.git
    cd giTerminal
    cp ./giTerminal.sh ..
    cp ./updater.sh ..
    cp -r ./helpers ..
    cd ..
    rm -rf giTerminal
}

update