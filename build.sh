BASE=base.nes
SRC=patch.asm
OUT=out

echo "INCNES \"$BASE\"" > inc-base.asm
which asm6f > /dev/null
if [ $? != 0 ]
then
    echo "asm6f is not on the PATH."
    continue
fi

asm6f -c -n -i "-dUSEBASE" "$SRC" "$OUT.nes"

if [ $? != 0 ]
then
    echo "error building."
    exit
fi

ipsnect "$OUT.ips" > "$OUT.map"