method Double(a: array<int>)
    requires a.Length == 2
    ensures a[0] == 2*old(a[0])
    ensures a[1] == 2*old(a[1])
    modifies a
{
    a[0] := 2 * a[0];
    a[1] := a[1] + a[1];
}
