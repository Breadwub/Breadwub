// Algorithm 1: Find an element in the array
method Find(a : array<int>, v : int) returns (index : int)
    // ensure index ≥ 0 → index < a.Length ∧ a[index] = v
    ensures index >= 0 ==> index < a.Length && a[index] == v
    // ensures index < 0 → ∀k. 0 ≤ k < a.Length → a[k] ̸= v
    ensures index < 0 ==> forall k: int :: 0 <= k < a.Length ==> a[k] != v
{
    var i : int := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant forall k: int :: 0 <= k < i ==> a[k] != v
    {
        if a[i] == v{
            return i;
        }
        i := i + 1;
    }
    return -1;
}


// Algorithm 2: Sum of 10n + 10(n − 1) + . . . + 10
method Sum(n : int) returns (sum : int)
    // requires n > 0
    requires n > 0
    // ensures sum = 5n × (n + 1)
    ensures sum == 5*n * (n+1)
{
    sum := 0;
    var i : int := n;
    while i > 0
        invariant 0 <= i <= n
        invariant sum == 5*(n-i) * (n+i+1)
    {
        var k : int := 0;
        var j : int := i;
        while j > 0
            invariant 0 <= j <= i
            invariant k == 10 * (i-j)
        {
            k := k + 10;
            j := j - 1;
        }
        sum := sum + k;
        i := i - 1;
    }
}


// Algorithm 3: Find the minimum value min in the array
method ArrayMin(a : array<int>) returns (min : int)
    // Given a non-empty array of integers...
    requires a.Length > 0
    // min is less than or equal to all elements in the array
    ensures forall j : int :: 0 <= j < a.Length ==> min <= a[j]
    // min is equal to some element in the array
    ensures exists j : int :: 0 <= j < a.Length && min == a[j]
{
    min := a[0];
    var i : int := 1;   // Can set as 1 because min is already a[0]
                        // --> do not need to compapre a[0] with a[0] when i = 0 in the while loop.
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant forall j : int :: 0 <= j < i ==> min <= a[j]
        invariant exists j : int :: 0 <= j < i && min == a[j]
    {
        if min > a[i]{
            min := a[i];
        }
        i := i + 1;
    }
}


// Algorithm 4:  Given an array of coins showing either Front or Back side on top, 
//               write a program with a "SortCoins" method that sorts the coins.
datatype Coin = Front | Back

predicate Before(c1: Coin, c2: Coin)
{
    c1 == Front || c1 == c2 || c2 == Back
}

method SortCoins(a: array<Coin>)
    // The sorted array is a permutation of the original array
    ensures multiset(a[..]) == multiset(old(a[..]))
    // All coins showing the Front side occur before those showing Back
    ensures forall i, j :: 0 <= i < j < a.Length ==> Before(a[i], a[j])
    modifies a
{
    var f := 0;
    var b := a.Length;
    while f < b
        invariant 0 <= f <= b <= a.Length
        invariant multiset(a[..]) == multiset(old(a[..]))
        invariant forall i : int :: 0 <= i < f ==> a[i] == Front
        invariant forall i : int :: b <= i < a.Length ==> a[i] == Back
    {
        match a[f]
        case Front =>
            f := f + 1;
        case Back =>
            b := b - 1;
            a[b], a[f] := a[f], a[b];
    }
}