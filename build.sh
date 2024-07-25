BASE=base
SRC=patch
OUT=out

builds=("us" "jp")

for build in "${builds[@]}"; do
    if [ ! -f $BASE-$build.nes ]; then
        echo "no base: $BASE-$build.nes"
        continue
    fi
    echo "INCNES \"$BASE-$build.nes\"" > inc-base.asm
    which asm6f > /dev/null
    if [ $? != 0 ]
    then
        echo "asm6f is not on the PATH."
        continue
    fi

    asm6f -c -n -i "-dUSEBASE" "-dBUILD_${build^^}" "$SRC-$build.asm" "$OUT-$build.nes"

    if [ $? != 0 ]
    then
        echo "error building."
        exit
    fi

    ipsnect "$OUT-$build.ips" > "$OUT-$build.map"
done