"use strict";
import * as MersenneTwister from "mersenne-twister";
import { Generator } from "./abc-path";

const is_mt: boolean = process.argv.length > 2 && process.argv[2] == "--mt";

for (let i = 1; i <= 100; ++i) {
    let gen;
    if (is_mt) {
        const r = new MersenneTwister(i);
        const max_rand = (m) => {
            return r.random_int() % m;
        };
        gen = new Generator({ max_rand: max_rand });
    } else {
        gen = new Generator({ seed: i });
    }
    const riddle = gen.calc_riddle();
    console.log("ABC Path Solver Layout Version 1:");
    console.log(riddle.get_riddle_v1_string());
}
console.log("Finished Generating Deals. Exiting.");
