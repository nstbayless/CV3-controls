#!/bin/bash

_force=false
flips="./flips/flips.exe"

while getopts ":f" opt; do
  case ${opt} in
    f ) #force
      _force=true
  esac
done

if [ ! -f base.nes ]
then
  >&2 echo "No base.nes ROM detected; cannot generate working.nes"
  exit 4;
else
  if [ -f working.nes ]
  then
    if [ "$_force" = false ]
    then
      >&2 echo "working.nes already exists. Rerun with -f flag to force overwriting working.nes"
      exit 1;
    else
      echo "Replacing existing working.nes"
      rm working.nes
    fi
  fi
  echo "Generating working.nes..."
  op=`uname`
  
  if [ "$op" = "Linux" ]
  then
    flips="./flips/flips-linux"
  fi
  
  if [ ! -f $flips ]
  then
      >&2 echo "flips not found; do you have the flips/ folder?"
      exit 2;
  fi
  
  cp base.nes working.nes
  if [ ! $? -eq 0 ]
  then
    >&2 echo "Error creating working.nes"
    exit 3;
  fi
  
  chmod u+x $flips
  
  $flips --apply patch.ips working.nes
  exit $?
fi
