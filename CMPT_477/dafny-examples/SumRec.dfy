method SumRec(n: int) returns (sum: int)
    requires n >= 0
    ensures sum == n * (n+1) / 2
{
    if (n <= 0) {
        sum := 0;
    } else {
        var t: int := SumRec(n-1);  
        /*  
            For method contract (step 1):
            Note: replace n's in pre/postconditions with "n-1":
                assert(n - 1 >= 0);
                assume(tmp = (n-1)*(n-1+1)/2);
                t := tmp;
        */  
        sum := n + t;
    }
}
