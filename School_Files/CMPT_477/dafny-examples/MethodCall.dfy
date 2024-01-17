method Foo(x: int) returns (y: int)
    ensures x >= 0 ==> y == 2*x
    ensures x < 0 ==> y == -2*x
{
    if (x > 0) {
        y := x + x;
    } else {
        y := -2 * x;
    }
}

method Bar(x: int) returns (y: int)
    ensures y == 10
{
    var t1: int := Foo(2);
    var t2: int := Foo(-3);
    y := t1 + t2;
}
