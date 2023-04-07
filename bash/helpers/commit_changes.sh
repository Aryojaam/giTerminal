#!/usr/bin/env bash
function commit_changes {
# if the user is still on master
if `git status | grep -q origin/master > /dev/null`; then
    echo "Currently on master. would you like to switch to a new branch? y/n"
    read -e answer
    if [ "$answer" = 'y' ] || [ "$answer" = 'Y' ]; then
        branchName=
        while [[ $branchName = "" ]]; do
            echo "How should I name the branch?"
            read -e branchName
        done
        git checkout -b $branchName
    fi
fi

if `git status | grep -q Untracked > /dev/null`; then
    echo "You have untracked files, would you like to stage them? y/n"
    read -e shouldStage
    if [ "$shouldStage" = 'y' ] || [ "$shouldStage" = 'Y' ]; then
        git add .
    fi
fi

# repeat until input is not empty
commitMessage=
while [[ $commitMessage = "" ]]; do
    echo "Please enter a commit message"
    read -e commitMessage
done

git commit -am "$commitMessage"

echo "Changes commited successfully. Would you like to push these changes? y/n"
read -e shouldPush
if [ "$shouldPush" = 'y' ] || [ "$shouldPush" = 'Y' ]; then
    if git status | grep origin/; then
            git push
    else
            branch="$(git status | grep branch | cut -c 11-)"
            git push -u origin ${branch}
    fi
fi
}