"use strict";
import * as MersenneTwister from "mersenne-twister" ;
import { Generator } from "./abc-path";
for (let i=1; i <= 100; ++i) {
    const r = new MersenneTwister(i);
    const max_rand = (m) => {return r.random_int() % m;};
    const gen = new Generator({ max_rand: max_rand, });
    const riddle = gen.calc_riddle();

    console.log("ABC Path Solver Layout Version 1:");
    console.log(riddle.get_riddle_v1_string());
}
