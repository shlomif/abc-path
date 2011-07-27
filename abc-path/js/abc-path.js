"use strict";
Class('ABC_Path', {
});
Class('ABC_Path.Constants', {
    methods: {
        LEN : function () {
            return 5;
        },
        LEN_LIM : function () {
            return (this.LEN()-1);
        },
        BOARD_SIZE : function() {
            return this.LEN() * this.LEN();
        },
        
        Y : function() {
            return 0;
        },

        X : function() {
            return 1;
        },

        letters : function() {
            return [
                'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
            'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y',
            ];
        },

        NUM_CLUES : function() {
            return 2 + this.LEN() + this.LEN();
        },

        ABCP_MAX_LETTER : function() {
            return this.letters().length - 1;
        }
    }
});
Class('ABC_Path.Solver', {
});
Class('ABC_Path.Solver.Base', {
    isa: ABC_Path.Constants,
    methods: {
        _xy_to_int: function(xy) {
            return xy[this.Y()] * this.LEN() + xy[this.X()];
        },
        _to_xy: function(myint) {
            return [Math.floor(myint / this.LEN()), (myint % this.LEN())];
        },
        _perl_range: function(start, end) {
            var ret = [];
            
            for (var i = start; i <= end; i++) {
                ret.push(i);
            }

            return ret;
        },
        _y_indexes: function() {
            return this._perl_range(0,this.LEN_LIM());
        },
    },
});
