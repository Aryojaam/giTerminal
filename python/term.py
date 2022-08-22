#!/usr/bin/python3

from helpers.utils import runCommand
from helpers.selectFromOptions import selectFromOptions
import commands as commands

isGitDirectory = commands.isGitDirectory()
if (not isGitDirectory):
    print("This is not a git repository. Exiting... Bye :(")
    exit(1)

gitDirectoryPath = runCommand("git rev-parse --git-dir")

options = [
    "Select branch",
    "Select remote branch",
    "Delete multiple branches",
    "Create PR",
    "Merge PR",
    "Commit and push"
]
option = selectFromOptions(options=options, title="Welcome to giTerminal! What do you wanna do?")

if (option == options[0]):
    commands.selectBranch(gitDirectoryPath)
if (option == options[1]):
    commands.selectRemoteBranch(gitDirectoryPath)
if (option == options[2]):
    commands.deleteMultipleBranch(gitDirectoryPath)
if (option == options[3]):
    commands.createPR(gitDirectoryPath)
if (option == options[4]):
    commands.mergePR(gitDirectoryPath)
if (option == options[5]):
    commands.commitAndPush(gitDirectoryPath)
