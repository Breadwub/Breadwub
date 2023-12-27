method TriangleNumber(N: int) returns (t: int)
    requires 0 <= N
    ensures t == N * (N+1) / 2
{
    t := 0;
    // Dafny can do type inference; don't need to 'var i: int := 0'
    var i := 0;         
    while i < N
        invariant 0 <= i <= N
        invariant t == i * (i+1) / 2 
    {
        i := i + 1;
        t := t + i;
    }
}
