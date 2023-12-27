method TriangleNumFor(N: int) returns (t: int)
    requires 0 <= N
    ensures t == N * (N-1) / 2
{
    t := 0;
    for i: int := 0 to N
        invariant 0 <= i <= N   // Optional to add if using for loop.
        invariant t == i * (i-1) / 2
    {
        t := t + i;
    }
}
