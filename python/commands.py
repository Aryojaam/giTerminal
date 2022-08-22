import os
from blessed import Terminal
from helpers.utils import printNoLB, readline, runCommand
from helpers.selectFromOptions import selectFromOptions
from helpers.selectMultipleFromOptions import selectMultipleFromOptions
term = Terminal()

def isGitDirectory():
    return runCommand("git rev-parse --is-inside-work-tree")

def getGitDir():
    return runCommand("git rev-parse --git-dir ..")

def getCurrentBranch():
    return runCommand("git rev-parse --abbrev-ref HEAD")

def selectBranch(gitDirectoryPath):
    currentBranch = getCurrentBranch()
    branches = runCommand(f"ls -A {gitDirectoryPath}/refs/heads/").replace(currentBranch, f"*{currentBranch}").split('\n')
    selected = selectFromOptions(options=branches, title="Select branch").replace('*', '')
    runCommand(f"git checkout {selected}")

def selectRemoteBranch(gitDirectoryPath):
    print("fetching all remotes please wait...")
    runCommand("git fetch --all -q")
    remotes = runCommand(f"ls -A {gitDirectoryPath}/refs/remotes/").split('\n')
    remote = selectFromOptions(options=remotes, title="Select remote")
    branches = runCommand(f"ls -A {gitDirectoryPath}/refs/remotes/{remote}").split('\n')
    selected = selectFromOptions(options=branches, title="Select branch")
    runCommand(f"git checkout {selected}")

def deleteMultipleBranch(gitDirectoryPath):
    currentBranch = getCurrentBranch()
    branches = runCommand(f"ls -A {gitDirectoryPath}/refs/heads/").replace(currentBranch, f"*{currentBranch}").split('\n')
    selected = selectMultipleFromOptions(
        options=branches,
        title=f"Currenty on branch {term.bold(term.darkgreen(currentBranch))}. Mark branches with Space-key and then press return to delete them"
    )
    for s in selected:
        runCommand(f"git branch -D {s.replace('*', '')}")

def makeYNChoice(choice):
    printNoLB(choice)
    with term.cbreak(), term.hidden_cursor():
        value = term.inkey()
        print(value)
        return value == "y" or value == "Y"

def createPR(gitDirectoryPath):
    currentBranch = getCurrentBranch()
    # change branch if needed
    if (currentBranch == "master" or currentBranch == "staging"):
        createNewBranch = makeYNChoice(f"Currently on branch {term.bold(currentBranch)}. Would you like to switch to a new branch? y/n ")
        if (createNewBranch):
            print("Enter branch name")
            branchName = readline(term=term)
            runCommand(f"git checkout -b {branchName}")
            currentBranch = getCurrentBranch()

    # stage untracked file
    hasUntrackedFiles = runCommand("git ls-files --others --exclude-standard") != ""
    if (hasUntrackedFiles):
        stageFiles = makeYNChoice("You have untracked files, would you like to stage them? y/n")
        if (stageFiles):
            runCommand("git add .")

    print("Please enter a commit message")
    commitMessage = readline(term=term)
    # need to use os.system since runCommand splits arguments
    os.system(f'git commit -am "{commitMessage}"')

    originRemoteBranches = runCommand(f"ls -A {gitDirectoryPath}/refs/remotes/origin/").split('\n')
    if currentBranch in originRemoteBranches:
        runCommand("git push")
    else:
        runCommand(f"git push -u origin {currentBranch}")


    print("Please enter a ticket number")
    ticket = readline(term=term)

    branches = runCommand(f"ls -A {gitDirectoryPath}/refs/heads/")
    baseBranch = selectFromOptions(options=branches, title="Select a base branch for the PR").split('\n')
    # need to use os.system since runcommand splits arguments
    os.system(f'gh pr create -B {baseBranch} -t {ticket};{commitMessage}')