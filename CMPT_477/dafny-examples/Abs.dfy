method Abs(x: int) returns (y: int)
    ensures y >= 0
{
    if x < 0 {
        return -x;
    } else {
        return x;
    }
}
