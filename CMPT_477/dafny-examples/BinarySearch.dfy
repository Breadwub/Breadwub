predicate sorted(a: array<int>)
    ensures forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]

method BinarySearch(a: array<int>, value: int) returns (index: int)
    requires sorted(a);
    ensures index >= 0 ==> index < a.Length && a[index] == value
    ensures index <  0 ==> forall k :: 0 <= k < a.Length ==> a[k] != value
{
    var low := 0;
    var high := a.Length;
    while (low < high)
        invariant 0 <= low <= high <= a.Length
        invariant forall i :: 0 <= i < low ==> a[i] != value
        invariant forall i :: high <= i < a.Length ==> a[i] != value
	{
        var mid := (low + high) / 2;
        if (value < a[mid]) {
            high := mid;
        } else if (a[mid] < value) {
            low := mid + 1;            
        } else {
            return mid;
        }
    }
    return -1;
}
