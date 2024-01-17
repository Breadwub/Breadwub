function Foo(x: int): int
    ensures x >= 0 ==> Foo(x) == 2*x
    ensures x < 0 ==> Foo(x) == -2*x
{
    if (x > 0) then x + x else -2 * x
}

method Bar() returns (y: int)
    ensures Foo(2) + Foo(-3) == y
{
    y := 10;
}
