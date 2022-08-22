from blessed import Terminal
from helpers.utils import runCommand
from helpers.selectFromOptions import selectFromOptions
from helpers.selectMultipleFromOptions import selectMultipleFromOptions
term = Terminal()

def isGitDirectory():
    return runCommand("git rev-parse --is-inside-work-tree")

def getGitDir():
    runCommand("git rev-parse --git-dir ..")

def selectBranch(gitDirectoryPath):
    currentBranch = runCommand("git rev-parse --abbrev-ref HEAD")
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
    currentBranch = runCommand("git rev-parse --abbrev-ref HEAD")
    branches = runCommand(f"ls -A {gitDirectoryPath}/refs/heads/").replace(currentBranch, f"*{currentBranch}").split('\n')
    selected = selectMultipleFromOptions(
        options=branches,
        title=f"Currenty on branch {term.bold(term.darkgreen(currentBranch))}. Mark branches with Space-key and then press return to delete them"
    )
    for s in selected:
        runCommand(f"git branch -D {s.replace('*', '')}")
