#!/usr/bin/env bash

ESC=$( printf "\033")

# normal font colors
black()   { printf "$ESC[30;1m$1$ESC[m"; }
red()     { printf "$ESC[31;1m$1$ESC[m"; }
green()   { printf "$ESC[32;1m$1$ESC[m"; }
yellow()  { printf "$ESC[33;1m$1$ESC[m"; }
blue()    { printf "$ESC[34;1m$1$ESC[m"; }
magenta() { printf "$ESC[35;1m$1$ESC[m"; }
cyan()    { printf "$ESC[36;1m$1$ESC[m"; }
white()   { printf "$ESC[37;1m$1$ESC[m"; }

