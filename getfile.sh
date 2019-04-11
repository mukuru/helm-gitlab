#!/usr/bin/env sh

#set -x # Enable for debugging
set -e

URI=$@ # eg: gitlab://token-xxx:xxxxx@gitlab.com/mukuru/ci-pipeline-templates:add_helm_repo/charts
FILEPATH=$(echo $URI | rev | cut -d: -f1 | rev) # eg: helm-charts
BRANCH=$(echo $URI | rev | cut -d: -f2 | rev) # eg: master
REPO_PATH=https:$(echo $URI | cut -d: -f2-3)

# make a temporary dir
TMPDIR="$(mktemp -d)"
cd $TMPDIR

git clone --single-branch --branch $BRANCH --depth=1 --quiet \
  $REPO_PATH.git .

if [ -f $FILEPATH ]; then # if a file named $FILEPATH exists
  cat $FILEPATH
else
  echo "Error in plugin 'helm-git': $BRANCH:$FILEPATH does not exists" >&2
  exit 1
fi

# remove the temporary dir
rm -rf $TMPDIR
