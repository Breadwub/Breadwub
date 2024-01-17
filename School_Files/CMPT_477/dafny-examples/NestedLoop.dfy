method NestedLoop(n: int) returns (sum: int)
    requires n > 0
    ensures sum == n * (n+1)
{
    sum := 0;
    var i: int := 0;
    while i <= n
        invariant 0 <= i <= n+1
        invariant sum == i * (i-1)
    {
        var k: int := 0;
        var j: int := 0;
        while j < i
            invariant 0 <= j <= i
            invariant k == 2 * j
        {
            k := k + 2;
            j := j + 1;
        }
        sum := sum + k;
        i := i + 1;
    }
}
