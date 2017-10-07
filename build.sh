#!/bin/bash

#
# Trigger the automatic building process on docker cloud.
#
# usage:
#     ./build.sh [version]
# notice:
#     the rebuilding of a specified version is not supported for now.
#

URL='https://www.rust-lang.org/en-US/'
SED_P='/release-version/{s/.*<span>\(.*\)<\/span>.*/\1/p;q}'
BASH_P="^[1-9][0-9]*\.[0-9]+\.[0-9]+$"

TAG="$1"

if [ -z "$TAG" ]; then
    TAG=`curl -s "$URL" | sed -n "$SED_P"`
    echo "Use version \"$TAG\" from $URL"
fi

if [[ ! "$TAG" =~ $BASH_P ]]; then
    echo "Bad format of release version!" > /dev/stderr
    exit 1
fi

__BRANCH__=`git branch | awk '$1=="*" {print $2}'`

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

git checkout $__BRANCH__
