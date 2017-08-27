#!/bin/bash
# creates a patch based on the difference between base.rom and working.rom

# find flips patcher:
flips="./flips/flips.exe"

if [ "$op" = "Linux" ]
then
  flips="./flips/flips-linux"
fi

if [ ! -f $flips ]
then
    >&2 echo "flips not found; do you have the flips/ folder?"
    exit 2;
fi

echo "Generating patch.ips..."

chmod u+w patch.ips

rm patch.ips

$flips --create --ips base.nes working.nes patch.ips
err=$?

chmod u+r patch.ips
chmod a-wx patch.ips

exit $?
