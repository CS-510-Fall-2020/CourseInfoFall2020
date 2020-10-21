#!/bin/bash

for i in directory/{1..5}/tt.text; do
    mkdir -p directory/{1..5} |
    touch directory/{1..5}/tt.text |
    echo "line 1
line 2
line 3
line 4
line 5" > $i
done
