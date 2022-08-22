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

def commitAndPush(gitDirectoryPath):
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
    runCommand('git commit -am "{commitMessage}"')

    # shouldPush = makeYNChoice("Changes committed successfully. Would you like to push these changes? y/n ")
    # if (shouldPush):
    originRemoteBranches = runCommand(f"ls -A {gitDirectoryPath}/refs/remotes/origin/").split('\n')
    if currentBranch in originRemoteBranches:
        runCommand("git push")
    else:
        runCommand(f"git push -u origin {currentBranch}")


def createPR(gitDirectoryPath):
    commitAndPush(gitDirectoryPath)

# if `git status | grep -q Untracked > /dev/null`; then
#     echo "You have untracked files, would you like to stage them? y/n"
#     read -e shouldStage
#     if [ "$shouldStage" = 'y' ] || [ "$shouldStage" = 'Y' ]; then
#         git add .
#     fi
# fi

# # repeat until input is not empty
# commitMessage=
# while [[ $commitMessage = "" ]]; do
#     echo "Please enter a commit message"
#     read -e commitMessage
# done

# git commit -am "$commitMessage"

# echo "Changes commited successfully. Would you like to push these changes? y/n"
# read -e shouldPush
# if [ "$shouldPush" = 'y' ] || [ "$shouldPush" = 'Y' ]; then
#     if git status | grep origin/; then
#             git push
#     else
#             branch="$(git status | grep branch | cut -c 11-)"
#             git push -u origin ${branch}
#     fi
# fi
# }
