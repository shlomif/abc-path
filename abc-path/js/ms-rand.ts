"use strict";
/*
 * Microsoft C Run-time-Library-compatible Random Number Generator
 * Copyright by Shlomi Fish, 2011.
 * Released under the MIT/X11 License
 * ( http://en.wikipedia.org/wiki/MIT_License ).
 * */
export class MSRand {
    private seed: number;
    constructor(s) {
        this.seed = s.seed;
    }
    getSeed() {
        return this.seed;
    }
    setSeed(s) {
        return (this.seed = s);
    }
    rand() {
        this.setSeed((this.getSeed() * 214013 + 2531011) & 0x7fffffff);
        return (this.getSeed() >> 16) & 0x7fff;
    }
    max_rand(mymax) {
        return this.rand() % mymax;
    }
    shuffle(deck: any[]) {
        if (deck.length) {
            let i = deck.length;
            while (--i) {
                const j = this.max_rand(i + 1);
                const tmp = deck[i];
                deck[i] = deck[j];
                deck[j] = tmp;
            }
        }
        return deck;
    }
}
