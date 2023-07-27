#!/usr/bin/env sh
if [ "$1" != "no-comp" ]; then
ghc -no-keep-hi-files -no-keep-o-files -O2 quicksortslow.hs -o bin/hqsslow
ghc -no-keep-hi-files -no-keep-o-files -O2 quicksort.hs -o bin/hqs
gcc -O2 qs.c -o bin/cqs
fi

cd bin/

printf "=== C ===\n"
time ./cqs > /dev/null
printf "=== Clean code ===\n"
time ./hqsslow > /dev/null
printf "=== ST Monad ===\n"
time ./hqs > /dev/null
