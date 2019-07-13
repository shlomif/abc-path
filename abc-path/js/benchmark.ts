"use strict";
import { Generator } from "./abc-path";
for (let i=1; i <= 100; ++i) {
    const gen = new Generator({ seed: i });
    const riddle = gen.calc_riddle();

    console.log("ABC Path Solver Layout Version 1:");
    console.log(riddle.get_riddle_v1_string());
}
