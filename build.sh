#!/bin/bash

# Trigger the automatic building process on docker cloud.
#
# usage:
#     ./build.sh [version]
# notice:
#     the rebuilding of a specified version is not supported for now.

cd $(dirname $(readlink -f $0))

VERSION="$1"

# Push to github
git_push() {
    if [ -z "$1" ] || [ "$1" = "master" ]; then exit 1; fi
    if [ -n "$GITHUB_API_KEY" ]; then
        REMOTE="https://liuchong:$GITHUB_API_KEY@github.com/liuchong/docker-rustup"
    else
        REMOTE=origin
    fi
    git push -f $REMOTE $1
}

# Modify global variable "VERSION", exit 1 if cannot get a valid version
get_version() {
    local URL='https://www.rust-lang.org'
    local VER_P="[1-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*"
    local SED_P="/Version/{s/.*Version \($VER_P\).*/\1/p;q}"

    if [ -z "$VERSION" ]; then
        echo "Trying to get version from $URL"
        VERSION=`curl -s "$URL" | sed -n "$SED_P"`
        echo "Use version \"$VERSION\" from $URL"
    else
        echo "Use version \"$VERSION\" from argument"
    fi

    if [[ ! "$VERSION" =~ ^$VER_P$ ]]; then
        echo "Bad format of release version!" > /dev/stderr
        VERSION=
        exit 1
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
    git_push build
    if [ -z "$VERSION" ]; then return; fi
    echo "Trigger versioning builds"
    git tag -d "$VERSION"
    git tag "$VERSION"
    git_push "$VERSION"
}

# Build it
build() {
    get_version
    versioning
    marking
    trigger
}

# Change current branch to "build" for preparing of building
start() {
    __BRANCH__=`git branch | awk '$1=="*" {print $2}'`
    git checkout master
    git branch -D build
    git checkout -b build
}

# Change branch back
end() {
    git checkout $__BRANCH__
    exit $1
}

main() {
    # Initialize
    trap 'end 0' RETURN
    trap 'end 1' SIGHUP SIGINT SIGQUIT SIGTERM
    start

    # Do the build
    build
}

main
