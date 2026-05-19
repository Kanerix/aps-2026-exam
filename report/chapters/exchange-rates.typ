== Cookie Selection - kasjo
Cookie Selection can be found at #link("https://open.kattis.com/problems/cookieselection").
The problem is about receiving cookies of some diameter, storing them, and, when requested, extracting the median cookie.
The input is at most 600 000 lines of either cookie size $n$, or "\#" when extracting a cookie.
$n$ can be anything between 1 and 300 000 000.
The output must be the diameter of each cookie when it is extracted, in the order of extraction.

=== Solution
There are two solutions to this problem. The first one uses a Fenwick tree, and the second uses a combination of a min-heap and a max-heap.

==== Fenwick Tree
The Fenwick tree solution uses an array where the value at index $i$ is the partial sum of cookies with the rank of $i$.
This partial sums is:
$
  "tree"[k] = "sumq"(k − p(k)+1, k)
$
where $k − p(k)+1$ is the lower bound, and k is the upper bound. This means that the partial sum at $i$ cannot contain values higher than $i$.

The solution uses a coordinate compression so as to not have 300 000 000 entries in the array.
This works because we know there will be at most 600 000 cookies.
This means that instead of having the value at $i$ be cookie diameter, it is rank instead.
The first parse process starts with collecting all input into an array $"vals"$ while ignoring any "\#".
Afterwards, it's moved to $"vals"$ while removing duplicates and sorting with pythons _timsort_.
Lastly the dictionary rank is built.

For the second parse, if the input is not a "\#", update(i, d) is called.
Update starts at $i$ (the rank), and increments the value at every index where the partial sum contains the cookie's rank. This is done through bit manipulation:
$
  i += i & -i
$
where $i$ is the index, jumping upwards until $i > m$, where m is the length of the tree.

If the input = \#, mid(k) is called:
$
  mid(n / 2 + 1)
$
where we want the _kth_ cookie, and n is incremented each time a cookie is added.
When searching, we set _nxt_ to:
$
  x + 2^i
$
where $x$ starts at 0, and $i$ starts as the bit length of $m$ (roughly log(m)), where $m$ is the length of the sorted distinct values $"coords"$.
In each iteration of the loop, we check if the partial sum at _nxt_ is less than k; $"fenwickTree"["nxt"] < k$ and if _nxt_ is within bounds.
If this check evaluates to true, we know the _kth_ element cannot be in the range.
Therefore, we set $x = "nxt"$ to pass it, while subtracting from $k$ the partial sum at _nxt_ to make up for what is skipped (such that it functions as a prefix sum).
If the check evaluates to false, we continue to the next iteration. After each iteration, $i$ is decremented by 1, such that the search always narrows.
Practically, this functions as a binary search.
After the last iteration, we will have moved $x$ as close to the median cookie rank as possible, without moving past it.
Therefore, we return $x+1$.
$"Coords"$ is used for reverting the rank back to cookie diameter, and ```python update(r, -1)``` is called to decrement the value at the appropriate ranks.

==== Min-heap and Max-heap
The idea is to maintain both a min-heap and a max-heap, and have them constantly balanced such that the median value can always be accessed from popping the minheap.
This solution simply uses the built-in python min-heap to efficiently handle both pushing and popping.
The min-heap is reverted by inputting -n for input n, and -popping to revert it again, effectively making it a max-heap.

Rebalancing is done a single time after each operation if necessary.

=== Running Time Discussion
==== Fenwick Tree
The Fenwick tree operations both have running time $O(log m)$ where m is distinct cookie sizes, worst case $m = N <= 600 000$.
The functions have the following running times:
- ```python update``` has a running time of O(log m), as the flipping of the bit can only happen at most log m times in the tree.
- ```python mid``` has a running time of O(log m), as it loops from $m."bit"_"length"()$ down to 0
The first parse is $O(N)$, where $N$ is the total lines of input.
Building the dict is $O(N)$
Coordinate compression is $O(N log N)$ with _timsort_.

==== Min-heap and Max-heap
The functions for the min-heap and max-heap have the following running times:
- ```python push``` O(log N)
- ```python pop``` O(log N)
- ```python total``` O(N log N)

=== Worst case input
As the operations themselves are always $O(log m)$ or $O(log N)$, the worst case input is simply 600 000 lines.
For the Fenwick tree, an input potentially ordered in some way difficult for _timsort_ to handle could make things slightly slower.

