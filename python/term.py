from utils import runCommand
from selectFromOption import selectFromOptions

isGitDirectory = runCommand("git rev-parse --is-inside-work-tree")
if (not isGitDirectory):
    print("This is not a git repository. Exiting... Bye :(")
    exit(1)

gitDirectoryPath = runCommand("git rev-parse --git-dir")
currentBranch = runCommand("git rev-parse --abbrev-ref HEAD")
branches = runCommand(f"ls -A {gitDirectoryPath}/refs/heads/").replace(currentBranch, f"*{currentBranch}").split('\n')
branch = selectFromOptions(options = branches, title="Select a branch to checkout")