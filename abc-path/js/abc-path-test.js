"use strict";
function test_abc_path()
{

    test("a basic test example", function() {
        ok( true, "this test is fine" );
        var value = "hello";
        equals( "hello", value, "We expect value to be hello" );
    });

    module("Module A");

    test("first test within module", function() {
        ok( true, "all pass" );
    });

    test("second test within module", function() {
        ok( true, "all pass" );
    });

    module("Module B");

    test("some other test", function() {
        expect(2);
        equals( true, true, "failing test" );
        equals( true, true, "passing test" );
    });

    module("Constants");

    test("Constants Test", function() {
        expect(9);

        var myconst = new ABC_Path.Constants({});

        // TEST
        ok (myconst, "myconst was initialized.");

        // TEST
        equals (myconst.LEN(), 5, "LEN is 5.");

        // TEST
        equals (myconst.LEN_LIM(), 4, "LEN_LIM is 4 - one less than LEN.");

        // TEST
        equals (myconst.BOARD_SIZE(), 25, "BOARD_SIZE is 25 - LEN*LEN.");

        // TEST
        equals(myconst.Y(), 0, "Y is 0.");

        // TEST
        equals(myconst.X(), 1, "X is 1, because coordinates are (Y,X)");

        // TEST
        equals(myconst.letters()[0], 'A', "First letter is A.");

        // TEST
        deepEqual(myconst.letters(), [
'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y',
            ],
            "Letters are OK."
            );

        // TEST
        equals(myconst.ABCP_MAX_LETTER(), 24, 'ABCP_MAX_LETTER is ok.');
    });

    module("Solver.Base");

    test("Solver.Base _xy_to_int", function() {
        expect(5);

        var mybase = new ABC_Path.Solver.Base({});

        // TEST
        ok (mybase, "myconst was initialized.");

        // TEST
        equals(mybase._xy_to_int([0,0]), 0, 'int of (Y,X) = [0,0] is 0.');
        // TEST
        equals(mybase._xy_to_int([0,1]), 1, 'int of (Y,X) = [0,1] is 1.');
        // TEST
        equals(mybase._xy_to_int([1,0]), 1*5+0, 'int of (Y,X) = [1,0] is 5.');
        // TEST
        equals(mybase._xy_to_int([2,3]), 2*5+3, 'int of (Y,X) = [2,3] is 2*5+3.');
    });

    test("Solver.Base _to_xy", function() {
        expect(3);

        var mybase = new ABC_Path.Solver.Base({});

        // TEST
        deepEqual(mybase._to_xy(0), [0,0], '_to_xy(0) -> [0,0]');

        // TEST
        deepEqual(mybase._to_xy(0*5+1), [0,1], '_to_xy(1) -> [0,1]');

        // TEST
        deepEqual(mybase._to_xy(3*5+4), [3,4], '_to_xy(3*5+4) -> [3,4]');
    });

    test("Solver.Base _y_indexes", function() {
        expect(4);

        var mybase = new ABC_Path.Solver.Base({});

        // TEST
        deepEqual(mybase._perl_range(0,2), [0,1,2], '_perl_range');

        // TEST
        deepEqual(mybase._perl_range(2,6), [2,3,4,5,6], '_perl_range #2');

        // TEST
        deepEqual(mybase._y_indexes(), mybase._perl_range(0, 4), 
            '_y_indexes returns right value.'
        );
        // TEST
        deepEqual(mybase._x_indexes(), mybase._perl_range(0, 4), 
            '_x_indexes returns right value.'
        );
    });
}
