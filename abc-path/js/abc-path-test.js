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

}
