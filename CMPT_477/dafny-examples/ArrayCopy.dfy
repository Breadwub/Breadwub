method ArrayCopy(a: array<int>, b: array<int>)
    requires a.Length <= b.Length
    ensures forall j: int :: 0 <= j < a.Length ==> b[j] == a[j]
    modifies b
{
    for i: int := 0 to a.Length
        invariant 0 <= i <= a.Length
        invariant forall j: int :: 0 <= j < i ==> b[j] == a[j]
    {
        b[i] := a[i];
    }
}
