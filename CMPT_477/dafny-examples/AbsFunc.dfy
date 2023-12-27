function Abs(x: int): int
    ensures Abs(x) >= 0
    ensures Abs(x) == x || Abs(x) == -x
{
    if x < 0 then -x else x
}
