#! /bin/bash

# Note: we expect 'bess' and 'S6' repos to be on the same level (of dirs)
# which could be different than $HOME
current_dir=`pwd`
# go up from 's6ctl' dir
parent_dir="$(dirname "$current_dir")"
# go one more up from 'S6' dir
parent_dir="$(dirname "$parent_dir")"
BESS_HOME=${parent_dir}/bess

BESS_CTL=$BESS_HOME/bin/bessctl

$BESS_CTL daemon reset 2> /dev/null
