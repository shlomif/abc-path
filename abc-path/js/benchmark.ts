"use strict";
import { MSRand } from "./ms-rand";
import { FinalLayoutObj , Generator } from "./abc-path";
import { Base, Board, Constants, shlomif_repeat } from "./abc-path-solver";
for (let i=1; i <= 100; ++i) {
    const gen = new Generator({ seed: i });
    const riddle = gen.calc_riddle();

    console.log("ABC Path Solver Layout Version 1:");
    console.log(riddle.get_riddle_v1_string());
}
