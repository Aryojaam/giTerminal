#!/usr/bin/env bash

function update {
    git clone https://github.com/Aryojaam/giterminal.git giterminalUpdate
    cd giterminalUpdate
    cp ./giterminal.sh ~/.giterminal/giterminal
    cp ./updater.sh ~/.giterminal/
    cp -r ./helpers ~/.giterminal/
    cd ..
    echo "removing cloned directory"
    rm -rf giterminalUpdate
}

update