#!/bin/bash
cd /Users/Rah/Desktop/directory/{1..5}
for x in *;
do
    y=$(echo $x|awk '{print substr($0,length($0),1)}')
    cd $x

    if [ $y -eq 1 ]; then
        sed -i '.bak' '4s/.*/eat\ beats/' tt.txt

    elif [ $y -eq 4 ]; then
        sed -i '.bak' '4s/.*/squash\ are\ great/' tt.txt

    elif [ $y -eq 5 ]; then
        sed -i '.bak' '4s/.*/dogs\ are\ better\ than\ cats/' tt.txt

    elif [ $y -eq 7 ]; then
        sed -i '.bak' '4s/.*/hello\ world/' tt.txt

    elif [ $y -eq 0 ]; then
        sed -i '.bak' '4s/.*/i\ like\ grapes/' tt.txt

    else
        sed -i '.bak' '4s/.*/\ /' tt.txt

    fi
    cd ..
 
done
cd ..


