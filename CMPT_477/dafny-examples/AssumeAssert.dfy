method AssumeAssert(x: int) returns (y: int)
{
    // P --> wp : {true ==> x > 0 ==> x + 1 > 1}    (which is valid)
    // P : {true}   (no precondition defined)
    // {x > 0 ==> x + 1 > 1}
    assume(x > 0);
    // {x + 1 > 1}
    y := x + 1;
    // {y > 1 /\ true} --> {y > 1}
    assert(y > 1);
    // {true} (no postcondition defined)

    // assume(x == 2);
    // y := x + 1;
    // assert(y == 3);
}
