method M(n: int) returns (ret: int)
    ensures n <= 100 ==> ret == 91
    ensures n > 100 ==> ret == n - 10
    /*
        - A "ranking function" used to prove something will terminate. 
        - A function from the itereation to a non-negative integer.
        - It is not trivial to see the function call/loop iteration is terminating.
        - "Everytime we call M(), we can guarantee 100-n is STRICTLY DECREASING"
        - "Ensure loop is going to terminate because ranking function is
           decreasing every iteration, and has lowerbound of 0."
    */
    decreases 100 - n   
{
    if (n > 100) {
        ret := n - 10;
    } else {
        ret := M(n + 11);
        ret := M(ret);
    }
}
