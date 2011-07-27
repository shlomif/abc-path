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

}
