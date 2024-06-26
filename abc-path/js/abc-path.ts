"use strict";
import { Base, Board, shlomif_repeat, string_repeat } from "./abc-path-solver";
import { MSRand } from "./ms-rand";
/*
 * ABC Path Solver and Generator.
 * Copyright by Shlomi Fish, 2011.
 * Released under the MIT/X11 License
 * ( http://en.wikipedia.org/wiki/MIT_License ).
 * */
export class FinalLayoutObj extends Base {
    public s;
    constructor(r) {
        super();
        this.s = r.s;
    }
    getS() {
        return this.s;
    }
    get_A_pos() {
        return this.getS().indexOf(String.fromCharCode(1));
    }
    get_A_xy() {
        var xy = this._to_xy(this.get_A_pos());
        return { y: xy[this.Y()], x: xy[this.X()] };
    }
    get_cell_contents(ind) {
        return this.getS().charCodeAt(ind);
    }
    get_letter_at_pos(mypos) {
        return this.letters()[
            this.get_cell_contents(this._xy_to_int([mypos.y, mypos.x])) - 1
        ];
    }
}
export class RiddleObj extends Base {
    public clues;
    public A_pos;
    constructor(r) {
        super();
        this.clues = r.clues;
        this.A_pos = r.A_pos;
    }
    get_clues_for_input_to_board() {
        var that = this;

        // Letter clues.
        var l_clues = that.clues.map(function(clue) {
            return clue.map(function(l_idx) {
                return that.letters()[l_idx - 1];
            });
        });

        return {
            clue_letter: "A",
            clue_letter_x: that.A_pos[that.X()],
            clue_letter_y: that.A_pos[that.Y()],
            major_diagonal: l_clues[0],
            minor_diagonal: l_clues[1],
            rows: l_clues.slice(2, 2 + 5),
            columns: l_clues.slice(2 + 5, 2 + 5 + 5),
        };
    }
    get_riddle_v1_string(): string
    {
    let $self = this;

    let $s: string[] = shlomif_repeat(shlomif_repeat([' '], 7).concat(["\n"]), 7);

    $s[($self.A_pos[$self.Y()] + 1 ) * 8 + $self.A_pos[$self.X()] + 1] = 'A';

    const $clues = $self.clues;
    for (let $clue_idx=0; $clue_idx < $self.NUM_CLUES(); ++$clue_idx) {
        let pos =
              ( $clue_idx == 0 ) ? [ [ 0, 0 ], [ 6, 6 ] ]
            : ( $clue_idx == 1 ) ? [ [ 0, 6 ], [ 6, 0 ] ]
            : ( $clue_idx < ( 2 + 5 ) )
            ? [ [ 1 + $clue_idx - (2), 0 ], [ 1 + $clue_idx - (2), 6 ] ]
            : [ [ 0, 1 + $clue_idx - ( 2 + 5 ) ],
                [ 6, 1 + $clue_idx - ( 2 + 5 ) ]
            ];

        for(let $i = 0 ; $i <= 1 ; ++$i)
        {
            $s[ pos[$i][0] * 8 + pos[$i][1]] =
                $self.letters()[ $clues[$clue_idx][$i] - 1 ];
        }
    }

    return $s.join("");
}
}
export class Generator extends Base {
    public seed: number;
    public max_rand;
    public rander;
    private _get_next_cells_lookup;
    public _clues_positions;
    constructor(r) {
        super();
        const that = this;
        this.seed = r.seed;
        this.rander = new MSRand({ seed: this.seed });
        this.max_rand = (m) => {return that.rander.max_rand(m);};
        this._get_next_cells_lookup = (() => {
            var that = this;
            return this._perl_range(0, this.BOARD_SIZE() - 1).map(function(
                cell,
            ) {
                var s = that._to_xy(cell);
                return [].concat.apply(
                    [],
                    [
                        [-1, -1],
                        [-1, 0],
                        [-1, 1],
                        [0, -1],
                        [0, 1],
                        [1, -1],
                        [1, 0],
                        [1, 1],
                    ].map(function(offsets) {
                        var y = s[that.Y()] + offsets[that.Y()];
                        var x = s[that.X()] + offsets[that.X()];
                        return that._x_in_range(x) && that._y_in_range(y)
                            ? [that._xy_to_int([y, x])]
                            : [];
                    }),
                );
            });
        })();
        this._clues_positions = (() => {
            var that = this;

            var _gen_clue_positions = function(cb) {
                return that._x_indexes().map(cb);
            };

            var _gen_clue_int_positions = function(cb) {
                return _gen_clue_positions(cb).map(function(xy: number[]) {
                    return that._xy_to_int(xy);
                });
            };

            var callbacks = [].concat.apply(
                [],
                [
                    [
                        function(i) {
                            return [i, i];
                        },
                    ],
                    [
                        function(i) {
                            return [i, 4 - i];
                        },
                    ],
                    that._y_indexes().map(function(y) {
                        return function(x) {
                            return [y, x];
                        };
                    }),
                    that._x_indexes().map(function(x) {
                        return function(y) {
                            return [y, x];
                        };
                    }),
                ],
            );

            return callbacks.map(_gen_clue_int_positions);
        })();
    }
    _shuffle(deck) {
        if (deck.length) {
            var i = deck.length;
            while (--i) {
                var j = this.max_rand(i + 1);
                var tmp = deck[i];
                deck[i] = deck[j];
                deck[j] = tmp;
            }
        }
        return deck;
    }
    _get_next_cells(l, init_idx) {
        return this._get_next_cells_lookup[init_idx].filter(function(x) {
            return l.charCodeAt(x) == 0;
        });
    }
    _add_next_state(stack, orig_l, cell_int) {
        var l = this._replaceSubstring(
            orig_l,
            cell_int,
            cell_int + 1,
            String.fromCharCode(1 + stack.length),
        );

        stack.push([l, this._shuffle(this._get_next_cells(l, cell_int))]);

        return;
    }
    _get_num_connected(l) {
        var connectivity_stack = [l.indexOf("\0")];

        var connected = {};
        var count = 0;

        while (connectivity_stack.length > 0) {
            var myint = connectivity_stack.pop();

            if (!(myint in connected)) {
                count++;
                connected[myint] = true;
                connectivity_stack = connectivity_stack.concat(
                    this._get_next_cells(l, myint).filter(function(x) {
                        return !(x in connected);
                    }),
                );
            }
        }

        return count;
    }
    calc_final_layout() {
        var that = this;

        var dfs_stack = [];
        that._add_next_state(
            dfs_stack,
            string_repeat("\0", that.BOARD_SIZE()),
            that.max_rand(that.BOARD_SIZE()),
        );

        while (dfs_stack.length > 0) {
            var dfs_top = dfs_stack[dfs_stack.length - 1];

            var l = dfs_top[0];
            var last_cells = dfs_top[1];

            if (dfs_stack.length == that.BOARD_SIZE()) {
                return new FinalLayoutObj({ s: l });
            }

            var next_idx = last_cells.shift();

            if (
                typeof next_idx == "undefined" ||
                that._get_num_connected(l) !=
                    that.BOARD_SIZE() - dfs_stack.length
            ) {
                dfs_stack.pop();
            } else {
                that._add_next_state(dfs_stack, l, next_idx);
            }
        }
        throw "Not found 333!";
    }
    calc_riddle() {
        var that = this;

        var layout = that.calc_final_layout();

        var A_pos = layout.get_A_pos();

        var init_state = {
            pos_pairs: [],
            chosen_clue: -1,
            pos_taken: 0,
            clues: that._perl_range(1, that.NUM_CLUES()).map(function() {
                return { num_remaining: 5, cells: [] };
            }),
        };

        var mark = function(state, pos) {
            state.pos_taken |= 1 << pos;

            var xy = that._to_xy(pos);
            var y = xy[that.Y()];
            var x = xy[that.X()];

            var clues_indexes = [];
            if (y == x) {
                clues_indexes.push(0);
            }
            if (y == that.LEN() - 1 - x) {
                clues_indexes.push(1);
            }
            clues_indexes.push(2 + y);
            clues_indexes.push(2 + 5 + x);

            clues_indexes.forEach(function(clue) {
                state.clues[clue].num_remaining--;
                return;
            });

            return;
        };

        mark(init_state, A_pos);

        var dfs_stack = [init_state];

        DFS: while (dfs_stack.length > 0) {
            var last_state = dfs_stack[dfs_stack.length - 1];

            if (last_state.chosen_clue < 0) {
                var clues = that
                    ._perl_range(0, that.NUM_CLUES() - 1)
                    .map(function(idx) {
                        return [idx, last_state.clues[idx]];
                    })
                    .filter(function(pair) {
                        return pair[1].cells.length === 0;
                    })
                    .sort(function(a, b) {
                        var aa = a[1].num_remaining;
                        var bb = b[1].num_remaining;

                        if (aa < bb) {
                            return -1;
                        } else if (aa > bb) {
                            return 1;
                        } else {
                            return a[0] - b[0];
                        }
                    });

                if (clues.length == 0) {
                    // Yay! We found a configuration.
                    var handle_clue = function(clue) {
                        var cells = clue.cells;
                        return that._shuffle(cells).map(function(idx) {
                            return layout.get_cell_contents(idx);
                        });
                    };
                    var riddle = new RiddleObj({
                        solution: layout,
                        clues: last_state.clues.map(handle_clue),
                        A_pos: that._to_xy(A_pos),
                    });

                    var solver = new Board();
                    solver.input_from_clues(
                        riddle.get_clues_for_input_to_board(),
                    );
                    solver.solve();

                    if (solver.get_successes_text_tables().length != 1) {
                        // The solution is ambiguous
                        dfs_stack.pop();
                        continue DFS;
                    } else {
                        return riddle;
                    }
                }

                // Not enough for the clues there.
                if (clues[0][1].num_remaining < 2) {
                    dfs_stack.pop();
                    continue DFS;
                }

                var clue_idx = clues[0][0];
                last_state.chosen_clue = clue_idx;

                var positions = that._clues_positions[clue_idx].filter(function(
                    x,
                ) {
                    return (last_state.pos_taken & (1 << x)) == 0;
                });

                var pairs = [];

                for (
                    var first_idx = 0;
                    first_idx < positions.length - 1;
                    first_idx++
                ) {
                    for (
                        var second_idx = first_idx + 1;
                        second_idx < positions.length;
                        second_idx++
                    ) {
                        pairs.push([
                            positions[first_idx],
                            positions[second_idx],
                        ]);
                    }
                }

                last_state.pos_pairs = that._shuffle(pairs);
            }

            var chosen_clue = last_state.chosen_clue;
            var next_pair = last_state.pos_pairs.shift();

            if (!next_pair) {
                dfs_stack.pop();
                continue DFS;
            }

            var new_state = {
                chosen_clue: -1,
                pos_pairs: [],
                pos_taken: last_state.pos_taken,
                clues: last_state.clues.map(function(clue) {
                    var copy = { ...clue };
                    return copy;
                }),
            };

            next_pair.forEach(function(pos) {
                mark(new_state, pos);
                return;
            });

            new_state.clues[chosen_clue].cells = next_pair.slice(0);

            dfs_stack.push(new_state);
        }

        throw "Not found 222!";
    }
}
