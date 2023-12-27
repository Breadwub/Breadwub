class Counter
{
    var count: int;

    constructor(v: int)
        ensures count == v
    {
        count := v;
    }

    method increment()
        modifies this
        ensures count == old(count) + 1
    {
        count := count + 1;
    }

    method decrement()
        modifies this
        ensures count == old(count) - 1
    {
        count := count - 1;
    }
}

method Main()
{
    var c: Counter := new Counter(10);
    assert (c.count == 10);
    c.increment();
    c.increment();
    assert (c.count == 12);
    c.decrement();
    assert (c.count == 11);
}
