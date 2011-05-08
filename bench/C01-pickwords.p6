#! perl6

use v6;

say ~slurp("%*ENV<RAKBENCH_DIR>/src/unixdict.txt").words.pick(25);
