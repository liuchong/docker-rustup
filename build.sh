#!/bin/bash

TAG=$1

BRANCH=`git branch | awk '$1=="*" {print $2}'`

git checkout master

git branch -D build

git checkout -b build

DT="$(date --rfc-3339=seconds)"

echo -e "\n# Build\n\n$DT" >> README.md

git add README.md

git commit -m "$DT"

git push -f origin build

if [ $TAG ]; then
    git tag -d "$TAG"
    git tag "$TAG"
    git push -f origin "$TAG"
fi

git checkout $BRANCH
