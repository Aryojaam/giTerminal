#!/usr/bin/python3

import sys
import argparse
from helpers.utils import runCommand
from helpers.selectFromOptions import selectFromOptions
import commands as commands

isGitDirectory = commands.isGitDirectory()
if (not isGitDirectory):
    print("This is not a git repository. Exiting... Bye :(")
    exit(1)

gitDirectoryPath = runCommand("git rev-parse --git-dir")

if (len(sys.argv) == 1):
    options = [
        "Select branch",
        "Select remote branch",
        "Delete multiple branches",
        "Create PR",
        "Merge PR",
        "Approve PR",
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
        commands.approvePR(gitDirectoryPath)
    if (option == options[6]):
        commands.commitAndPush(gitDirectoryPath)
else: 
    parser = argparse.ArgumentParser()
    
    parser.add_argument("b", "branch", help="Slect branch")
    args = parser.parse_args()
    print(args)
    # if args.branch:
        # print("Selcet branch: % s" % args.branch)


    # parser.add_argument("--h", help="Show help")
    # parser.add_argument("b", help="Select branch")
    # parser.add_argument("r", help="Select remote branch")
    # parser.add_argument("d", help="Delete multiple branches")