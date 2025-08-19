"use strict";
import { MSRand } from "./ms-rand";
import { FinalLayoutObj, Generator } from "./abc-path";
import { Base, Board, Constants, shlomif_repeat } from "./abc-path-solver";
/*
 * Tests for the ABC Path Solver and Generator.
 * Copyright by Shlomi Fish, 2011.
 * Released under the Expat License
 * ( http://en.wikipedia.org/wiki/MIT_License ).
 * */
function test_abc_path() {
    const seedstr = process.argv[2];
    const seed = parseInt(seedstr, 10);
    const gen = new Generator({ seed: seed });
    const riddle = gen.calc_riddle();

    console.log(riddle.get_riddle_v1_string());
    return;
}

test_abc_path();
