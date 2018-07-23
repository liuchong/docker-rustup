#!/bin/bash

# Trigger the automatic building process on docker cloud.
#
# usage:
#     ./build.sh [version]
# notice:
#     the rebuilding of a specified version is not supported for now.

cd $(dirname $(readlink -f $0))

VERSION="$1"

# Modify global variable "VERSION", exit 1 if cannot get a valid version
get_version() {
    local URL='https://www.rust-lang.org/en-US/'
    local SED_P='/release-version/{s/.*<span>\(.*\)<\/span>.*/\1/p;q}'
    local BASH_P="^[1-9][0-9]*\.[0-9]+\.[0-9]+$"

    if [ -z "$VERSION" ]; then
        echo "Trying to get version from $URL"
        VERSION=`curl -s "$URL" | sed -n "$SED_P"`
        echo "Use version \"$VERSION\" from $URL"
    else
        echo "Use version \"$VERSION\" from argument"
    fi

    if [[ ! "$VERSION" =~ $BASH_P ]]; then
        echo "Bad format of release version!" > /dev/stderr
        VERSION=
    fi
}

# Modify the dockerfiles to change "stable" to a specified version
versioning() {
    if [ -z "$VERSION" ]; then
        echo "No version specified" > /dev/stderr
        return
    fi
    echo "Versioning dockerfiles of stable builds with $VERSION"
    find dockerfiles/ -name Dockerfile |\
        xargs sed -i /toolchain/s/stable/$VERSION/
    git add dockerfiles/
    git commit -m "modify stable dockerfiles version with \"$VERSION\""
}

# Mark the building with a date string in README.md
marking() {
    local DT="$(date --rfc-3339=seconds)"
    echo "Make a build date marking on README.md"
    echo -e "\n# Build\n\n$DT" >> README.md
    git add README.md
    git commit -m "$DT"
}

# Trigger
trigger() {
    echo "Trigger master/beta/nightly builds"
    git push -f origin build
    if [ -z "$VERSION" ]; then return; fi
    echo "Trigger versioning builds"
    git tag -d "$VERSION"
    git tag "$VERSION"
    git push -f origin "$VERSION"
}

# Build it
build() {
    get_version
    versioning
    marking
    trigger
}

# Change current branch to "build" for preparing of building
__BRANCH__=`git branch | awk '$1=="*" {print $2}'`
git checkout master
git branch -D build
git checkout -b build

# Do the build
build

# Change branch back
git checkout $__BRANCH__
