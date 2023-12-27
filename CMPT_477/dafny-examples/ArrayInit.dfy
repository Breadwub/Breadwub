method ArrayInit(a: array<int>)
    // No 'requires' = no specified precondition = P : {true}
    ensures forall j: int :: 0 <= j < a.Length ==> a[j] == 0
    modifies a  // a is 'potentially' modified
                // arrays are always treated as global variables
{
    var i: int := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant forall j: int :: 0 <= j < i ==> a[j] == 0 
    {
        a[i] := 0;
        i := i + 1;
    }
}
