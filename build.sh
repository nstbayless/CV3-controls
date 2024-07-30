BASE=base
SRC=patch
OUT=out

builds=("us" "jp")
vcancel_cfgs=("vcancel" "no-vcancel")
inertia_cfgs=("none" "light" "heavy")

export="cv3-controls"
set -e

which asm6f > /dev/null
if [ $? != 0 ]
then
    echo "asm6f is not on the PATH. asm6f with patching directives is required: https://github.com/freem/asm6f/pull/30"
    exit 1
fi

if [ -d "$export" ]
then
    rm -r $export
fi
mkdir $export
cp pkg_readme.md $export/README.md

for build in "${builds[@]}"; do
    if [ ! -f $BASE-$build.nes ]; then
        echo "no base: $BASE-$build.nes"
        continue
    fi
    echo "INCNES \"$BASE-$build.nes\"" > inc-base.asm
    mkdir $export/$build
    mkdir $export/$build/inertia
    
    for vcancel in "${vcancel_cfgs[@]}"; do
        
        for inertia in "${inertia_cfgs[@]}"; do
            defines=""
            
            suffix="$build"
            subpath="$build"
            if [ "$vcancel" == "vcancel" ]; then
                suffix="$suffix-$vcancel"
                defines="$defines -dVCANCEL"
            fi
            
            if [ "$inertia" == "none" ]; then
                defines="$defines -dINERTIA_64"
                true
            elif [ "$inertia" == "light" ]; then
                defines="$defines -dINERTIA_0"
                suffix="$suffix-light"
                subpath="$subpath/inertia"
            elif [ "$inertia" == "heavy" ]; then
                defines="$defines -dINERTIA_32"
                suffix="$suffix-heavy"
                subpath="$subpath/inertia"
            fi
            
            echo "building $suffix"
            
            set -x
            asm6f -c -n -i "-dUSEBASE" "-dBUILD_${build^^}" $defines "$SRC-$build.asm" "$OUT-$suffix.nes"
            set +x

            if [ $? != 0 ]
            then
                echo "error building."
                exit
            fi
            
            cp "$OUT-$suffix.ips" "$export/$subpath/$export-$suffix.ips"
            
            if command -v ipsnect >/dev/null 2>&1; then
                ipsnect "$OUT-$suffix.ips" > "$OUT-$suffix.map"
            fi
        done
    done
done

echo "============================================"
echo "Assembling export."

if [ -f cv3-controls.zip ]; then
    rm cv3-controls.zip
fi
zip -r cv3-controls.zip $export/*