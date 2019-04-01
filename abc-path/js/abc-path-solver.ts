import {
    ResultsInAnError,
    ResultsInASuccess,
    LastRemainingLetterForCell,
    TryingLetterForCell,
    LastRemainingCellForLetter,
    LettersNotInVicinity,
} from "./abc-path-move";
// Taken from http://stackoverflow.com/questions/202605/repeat-string-javascript
export function shlomif_repeat(arr, times) {
    "use strict";

    return times == 0 ? [] : arr.concat(shlomif_repeat(arr, times - 1));
}
export function string_repeat(arr, times) {
    "use strict";

    return times == 0 ? "" : arr + string_repeat(arr, times - 1);
}

export class Constants {
    LEN() {
        return 5;
    }
    LEN_LIM() {
        return this.LEN() - 1;
    }
    BOARD_SIZE() {
        return this.LEN() * this.LEN();
    }

    Y() {
        return 0;
    }

    X() {
        return 1;
    }

    letters() {
        return [
            "A",
            "B",
            "C",
            "D",
            "E",
            "F",
            "G",
            "H",
            "I",
            "J",
            "K",
            "L",
            "M",
            "N",
            "O",
            "P",
            "Q",
            "R",
            "S",
            "T",
            "U",
            "V",
            "W",
            "X",
            "Y",
        ];
    }

    NUM_CLUES() {
        return 2 + this.LEN() + this.LEN();
    }

    ABCP_MAX_LETTER() {
        return this.letters().length - 1;
    }
}
export class Base extends Constants {
    _xy_to_int(xy) {
        return xy[this.Y()] * this.LEN() + xy[this.X()];
    }
    _to_xy(myint) {
        return [Math.floor(myint / this.LEN()), myint % this.LEN()];
    }
    _perl_range(start, end) {
        var ret = [];

        for (var i = start; i <= end; i++) {
            ret.push(i);
        }

        return ret;
    }
    _y_indexes() {
        return this._perl_range(0, this.LEN_LIM());
    }
    _x_indexes() {
        return this._y_indexes();
    }
    _x_in_range(x) {
        return x >= 0 && x < this.LEN();
    }
    _y_in_range(y) {
        return this._x_in_range(y);
    }
    _replaceSubstring(s, start, end, replacement) {
        return s.substring(0, start) + replacement + s.substring(end);
    }
}
export class Board extends Base {
    // import Move = ABC_Path.Solver.Move;
    public letters_map;
    public _error;
    public _iter_changed: number;
    public _moves: any[];
    public _successful_layouts: any[];
    public _layout: any[];
    constructor() {
        super();
        this.letters_map = (() => {
            var ret = {};
            var l = this.letters();
            for (var i in l) {
                ret[l[i]] = parseInt(i);
            }
            return ret;
        })();
        this._iter_changed = 0;
        this._moves = [];
        this._error = undefined;
        this._successful_layouts = [];
        this._layout = [];
    }
    getLayout() {
        return this._layout;
    }
    setError(err) {
        return (this._error = err);
    }
    getError() {
        return this._error;
    }
    getMoves() {
        return this._moves;
    }
    getIter_changed() {
        return this._iter_changed;
    }
    setIter_changed(s) {
        this._iter_changed = s;
    }
    ABCP_VERDICT_NO() {
        return 0;
    }
    ABCP_VERDICT_MAYBE() {
        return 1;
    }
    ABCP_VERDICT_YES() {
        return 2;
    }
    _get_letter_numeric(letter_ascii) {
        if (letter_ascii in this.letters_map) {
            return this.letters_map[letter_ascii];
        } else {
            throw "Unknown letter '" + letter_ascii + "'";
        }
    }
    _inc_changed() {
        this.setIter_changed(this.getIter_changed() + 1);
        return;
    }
    _flush_changed() {
        var ret = this.getIter_changed();

        this.setIter_changed(0);

        return ret;
    }
    _add_move(move) {
        this.getMoves().push(move);
        this._inc_changed();
        return;
    }
    getSuccessful_layouts() {
        return this._successful_layouts;
    }
    get_successful_layouts() {
        // slice(0) performs a shallow copy.
        return this.getSuccessful_layouts().slice(0);
    }
    _l_indexes() {
        return this._perl_range(0, this.ABCP_MAX_LETTER());
    }
    _calc_offset(letter, x, y) {
        return letter * this.BOARD_SIZE() + this._xy_to_int([y, x]);
    }
    _get_verdict(letter, x, y) {
        return this.getLayout()[this._calc_offset(letter, x, y)];
    }
    _set_verdict(letter, x, y, verdict) {
        if (
            !(
                verdict == this.ABCP_VERDICT_NO() ||
                verdict == this.ABCP_VERDICT_MAYBE() ||
                verdict == this.ABCP_VERDICT_YES()
            )
        ) {
            throw "Invalid verdict " + verdict + ".";
        }

        this.getLayout()[this._calc_offset(letter, x, y)] = verdict;

        return;
    }
    _xy_loop(sub_ref) {
        var y_indexes = this._y_indexes();
        var x_indexes = this._x_indexes();

        for (var y_ in y_indexes) {
            var y = y_indexes[y_];
            if (this.getError()) {
                return;
            }
            for (var x_ in x_indexes) {
                var x = x_indexes[x_];
                if (this.getError()) {
                    return;
                }

                sub_ref(x, y);
            }
        }
        return;
    }
    _xy_to_s(x, y) {
        return "" + x + "," + y;
    }
    _set_verdicts_for_letter_sets(letter_list, maybe_list) {
        var board = this;

        var cell_is_maybe = new Array();

        maybe_list.forEach(function(m) {
            cell_is_maybe[board._xy_to_s(m[0], m[1])] = true;
        });

        letter_list.forEach(function(l) {
            var letter = board._get_letter_numeric(l);

            board._xy_loop(function(x, y) {
                board._set_verdict(
                    letter,
                    x,
                    y,
                    board._xy_to_s(x, y) in cell_is_maybe
                        ? board.ABCP_VERDICT_MAYBE()
                        : board.ABCP_VERDICT_NO(),
                );
            });
        });

        return;
    }
    _set_conclusive_verdict_for_letter(letter, xy_) {
        var xy = xy_.slice(0);
        var l_x = xy.shift();
        var l_y = xy.shift();

        var board = this;
        this._xy_loop(function(x, y) {
            board._set_verdict(
                letter,
                x,
                y,
                l_x == x && l_y == y
                    ? board.ABCP_VERDICT_YES()
                    : board.ABCP_VERDICT_NO(),
            );
        });

        var _l_indexes = this._l_indexes();
        for (var i in _l_indexes) {
            var other_letter = _l_indexes[i];
            if (other_letter != letter) {
                this._set_verdict(
                    other_letter,
                    l_x,
                    l_y,
                    board.ABCP_VERDICT_NO(),
                );
            }
        }
        return;
    }
    _get_possible_letter_indexes(x, y) {
        var board = this;
        return board._l_indexes().filter(function(l) {
            return board._get_verdict(l, x, y) != board.ABCP_VERDICT_NO();
        });
    }
    get_possible_letters_for_cell(x, y) {
        var board = this;
        return this._get_possible_letter_indexes(x, y).map(function(l) {
            return board.letters()[l];
        });
    }
    _get_possible_letters_string(x, y) {
        return this.get_possible_letters_for_cell(x, y).join(",");
    }
    _infer_letters() {
        var board = this;
        try {
            board._l_indexes().forEach(function(letter) {
                var true_cells = [];

                board._xy_loop(function(cx, cy) {
                    var ver = board._get_verdict(letter, cx, cy);

                    if (
                        ver == board.ABCP_VERDICT_YES() ||
                        ver == board.ABCP_VERDICT_MAYBE()
                    ) {
                        true_cells.push([cx, cy]);
                    }
                });

                if (true_cells.length == 0) {
                    board.setError(["letter", letter]);
                    throw "letter_error";
                } else if (true_cells.length == 1) {
                    var xy = true_cells[0];
                    if (
                        board._get_verdict(letter, xy[0], xy[1]) ==
                        board.ABCP_VERDICT_MAYBE()
                    ) {
                        board._set_conclusive_verdict_for_letter(letter, xy);
                        board._add_move(
                            new LastRemainingCellForLetter({
                                letter: letter,
                                coords: xy,
                            }),
                        );
                    }
                }

                var neighbourhood = board._y_indexes().map(function() {
                    return shlomif_repeat([false], board.LEN());
                });

                for (var t_i in true_cells) {
                    var true_cell = true_cells[t_i];

                    for (var dx = -1; dx <= 1; dx++) {
                        for (var dy = -1; dy <= 1; dy++) {
                            var cx = true_cell[0] + dx;
                            var cy = true_cell[1] + dy;

                            if (
                                board._x_in_range(cx) &&
                                board._y_in_range(cy)
                            ) {
                                neighbourhood[cy][cx] = true;
                            }
                        }
                    }
                }

                var neighbour_letters = [];
                if (letter > 0) {
                    neighbour_letters.push(letter - 1);
                }
                if (letter < board.ABCP_MAX_LETTER()) {
                    neighbour_letters.push(letter + 1);
                }

                neighbour_letters.forEach(function(neighbour_letter) {
                    board._xy_loop(function(x, y) {
                        if (neighbourhood[y][x]) {
                            return;
                        }

                        var existing_verdict = board._get_verdict(
                            neighbour_letter,
                            x,
                            y,
                        );

                        if (existing_verdict == board.ABCP_VERDICT_YES()) {
                            board.setError(["mismatched_verdict", x, y]);
                            return;
                        }

                        if (existing_verdict == board.ABCP_VERDICT_MAYBE()) {
                            board._set_verdict(
                                neighbour_letter,
                                x,
                                y,
                                board.ABCP_VERDICT_NO(),
                            );

                            board._add_move(
                                new LettersNotInVicinity({
                                    vars: {
                                        target: neighbour_letter,
                                        coords: [x, y],
                                        source: letter,
                                    },
                                }),
                            );
                        }
                    });
                });
            });
        } catch (err) {
            if (err != "letter_error") {
                throw err;
            }
        }

        return;
    }
    _infer_cells() {
        var board = this;
        board._xy_loop(function(x, y) {
            var letters_aref = board._get_possible_letter_indexes(x, y);

            if (letters_aref.length == 0) {
                board.setError(["cell", [x, y]]);
                return;
            } else if (letters_aref.length == 1) {
                var letter = letters_aref[0];

                if (
                    board._get_verdict(letter, x, y) ==
                    board.ABCP_VERDICT_MAYBE()
                ) {
                    board._set_conclusive_verdict_for_letter(letter, [x, y]);

                    board._add_move(
                        new LastRemainingLetterForCell({
                            vars: {
                                coords: [x, y],
                                letter: letter,
                            },
                        }),
                    );
                }
            }
            return;
        });

        return;
    }
    _inference_iteration() {
        this._infer_letters();
        this._infer_cells();
        return this._flush_changed();
    }
    _neighbourhood_and_individuality_inferring() {
        var num_changed = 0;

        var iter_changed;
        while ((iter_changed = this._inference_iteration())) {
            if (this.getError()) {
                return;
            }
            num_changed += iter_changed;
        }

        return num_changed;
    }
    _clone() {
        var ret = new Board();
        ret._layout = this.getLayout().slice(0);
        return ret;
    }
    get_moves() {
        return this.getMoves().slice(0);
    }
    // Performs the actual solution. Should be called after input.
    solve() {
        var board = this;

        this._neighbourhood_and_individuality_inferring();

        if (this.getError()) {
            return this.getError();
        }
        var min_coords;
        var min_options = [];

        board._xy_loop(function(x, y) {
            var letters_aref = board._get_possible_letter_indexes(x, y);

            if (letters_aref.length == 0) {
                board.setError(["cell", [x, y]]);
            } else if (letters_aref.length > 1) {
                if (!min_coords || letters_aref.length < min_options.length) {
                    min_options = letters_aref.slice(0);
                    min_coords = [x, y];
                }
            }

            return;
        });

        if (board.getError()) {
            return board.getError();
        }

        if (min_coords) {
            var x = min_coords.shift();
            var y = min_coords.shift();
            // We have at least one multiple rank cell. Let's recurse there:
            min_options.forEach(function(letter) {
                var recurse_solver = board._clone();

                board._add_move(
                    new TryingLetterForCell({
                        vars: { letter: letter, coords: [x, y] },
                    }),
                );

                recurse_solver._set_conclusive_verdict_for_letter(letter, [
                    x,
                    y,
                ]);

                recurse_solver.solve();

                recurse_solver.get_moves().forEach(function(move) {
                    board._add_move(move.bump());
                });

                if (recurse_solver.getError()) {
                    board._add_move(
                        new ResultsInAnError({
                            vars: {
                                letter: letter,
                                coords: [x, y],
                            },
                        }),
                    );
                } else {
                    board._add_move(
                        new ResultsInASuccess({
                            vars: { letter: letter, coords: [x, y] },
                        }),
                    );

                    recurse_solver.getSuccessful_layouts().forEach(function(e) {
                        board.getSuccessful_layouts().push(e);
                    });
                }
            });
            var count = board.getSuccessful_layouts().length;
            if (!count) {
                return ["all_options_bad"];
            } else if (count == 1) {
                return ["success"];
            } else {
                return ["success_multiple"];
            }
        } else {
            board._successful_layouts = [board._clone()];
            return ["success"];
        }
    }
    input_from_clues(clues) {
        var board = this;
        board._set_conclusive_verdict_for_letter(
            board._get_letter_numeric(clues.clue_letter),
            [clues.clue_letter_x, clues.clue_letter_y],
        );

        board._set_verdicts_for_letter_sets(
            clues.major_diagonal,
            board._y_indexes().map(function(y) {
                return [y, y];
            }),
        );
        board._set_verdicts_for_letter_sets(
            clues.minor_diagonal,
            board._y_indexes().map(function(y) {
                return [y, 4 - y];
            }),
        );
        board._x_indexes().forEach(function(x) {
            board._set_verdicts_for_letter_sets(
                clues.columns[x],
                board._y_indexes().map(function(y) {
                    return [x, y];
                }),
            );
        });
        board._y_indexes().forEach(function(y) {
            board._set_verdicts_for_letter_sets(
                clues.rows[y],
                board._x_indexes().map(function(x) {
                    return [x, y];
                }),
            );
        });
        return;
    }
    _get_results_text_table() {
        var board = this;
        var render_row = function(cols) {
            return (
                "| " +
                cols
                    .map(function(s) {
                        return s.length == 1 ? "  " + s + "  " : s;
                    })
                    .join(" | ") +
                " |\n"
            );
        };
        return [
            board._x_indexes().map(function(x) {
                return "X = " + (x + 1);
            }),
        ]
            .concat(
                board._y_indexes().map(function(y) {
                    return board._x_indexes().map(function(x) {
                        return board._get_possible_letters_string(x, y);
                    });
                }),
            )
            .map(render_row)
            .join("");
    }
    get_successes_text_tables() {
        return this.get_successful_layouts().map(function(l) {
            return l._get_results_text_table();
        });
    }
}
