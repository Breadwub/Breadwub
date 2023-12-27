method Even(n: int) returns (ret: bool)
    requires n >= 0
    ensures ret <==> n % 2 == 0
{
    if (n == 0) {
        ret := true;
    } else {
        ret := Odd(n-1);
    }
}

method Odd(n: int) returns (ret: bool)
    requires n >= 0
    ensures ret <==> n % 2 == 1
{
    if (n == 0) {
        ret := false;
    } else {
        ret := Even(n-1);
    }
}
 