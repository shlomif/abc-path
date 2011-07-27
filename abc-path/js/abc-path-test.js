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
        expect(3);

        var myconst = new ABC_Path.Constants({});

        // TEST
        ok (myconst, "myconst was initialized.");

        // TEST
        equals (myconst.LEN(), 5, "LEN is 5.");

        // TEST
        equals (myconst.LEN_LIM(), 4, "LEN_LIM is 4 - one less than LEN.");
    });

}
