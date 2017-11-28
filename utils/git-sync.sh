#!/bin/bash

# An unsophisticated script to sync a git repo. I use this to periodically sync
# my notes repository. There's pretty much no error checking, as this script
# is assumed to be running as a daemon on all my machines.
# TODO: Send a mail or something when things break.

if [ "$#" -ne 1 ]
then
  echo "Usage: git-sync.sh <dir>"
  exit 1
fi

cd $1
git rev-parse

if [ "$?" -ne "0" ]; then
   echo "Not in a git repository!";

fi

while true; do
  git pull origin master
  num_changes=`git status --porcelain | wc -l`
  les
  if (( $num_changes > 0)); then
    dt=`date`
    host=`hostname`
    commit="$num_changes files changed from $host at $dt"
    git add -A; git commit -m "$commit"; git push origin master
    echo $commit
  fi
  sleep 300
done
