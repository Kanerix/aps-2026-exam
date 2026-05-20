== Cookie Selection - akdy
Cookie Selection can be found at #link("https://open.kattis.com/problems/cookieselection").
The problem is about receiving cookies of some diameter $d$, storing them, and, when requested, extracting the median cookie.
The input is at most $1 <= n <= 600000$ lines of either cookie size $d$, or "\#" which means you must print the size of the median cookie and stop tracking it.
The value of $d$ must be in the interval $1 <= d <= 300000000$.
The output must be the diameter of each cookie when it is extracted, in the order of extraction.

=== Solution & Running Time
There are multiple solutions to this problem.
The following includes two potential solutions.
The first one uses a Fenwick tree, and the second uses a combination of a min-heap and a max-heap, henceforth referred to as a median-heap.

==== Fenwick Tree
The Fenwick Tree solution is backed by an array where the value at index $i$ is the partial sum of values prior to $i$.
This partial sums is defined as
$
  "tree"[k] = "sum"_q(k − p(k)+1, k)
$
where $p(k)$ is the larges power of 2, which divies $k$.
Since the $sum_q(a,b)$ defines the value stored in the backing array from the index $a$ to the index $b$.
Since each index of the tree defines a partial sum, this means that as we move up, the index start covering larger ranges within the array.

The solution compresses the diameters of the cookies, as this avoids having to story an array of length $300000000$ in memory.
Instead, cookie ranks are compressed, meaning, for example, that the least cookie diameter has rank 1.
#footnote[Fenwick Trees start at index to ease implementation]
This is done by first parsing the entire input, skipping "\#" characters and storing them in a list.
Afterwards, this list is sorted, and finally they are stored in a dictionary, where diameter $d$ point to their corresponding rank.
With this in place, the Fenwick tree can be constructed, where the backing array contains an index for each rank.
This allows us to perform queries on the cookie weights in the backing Fenwick Tree, which uses an index from 1 to $n$.

This initial preprocessing runs in $O(n*log(n))$, as it is linearly dominated by the sorting step.

Afterwards, the input is processed again.
If the input line is not the "\#" character, `update(k, d)` is called.
Update starts at $k$ (the rank), and increments the value at every index used to create the value at the current index.
In practice, this means it traverses up the tree from the index of $k$.
This is done through the bitwise operation $k =+ (k & -k)$, which moves $k$ to the next moves to the next index for the cumulative sum originating fro $k$.
Since the operation updates accesses $O(log(k))$ items in the backing array, it means that `update` has a running time of $O(log(n))$.

If the input line is the "\#" character, `mid(k)` is called.
`mid(k)` finds the cookie rank where the cumulative sum is $"rank" >= k$.
This is done by performing a binary search over the tree to find the specific $k$, which satisfies the above condition.
This rank is then looked up to find the original cookie diameter.
Finally, the cookie with rank $k$ is decreased by one.
This is done as the cookie has been "removed" from the packing facility.

Since the value of `nxt` is doubled through bit shifting, the `mid(k)` operator also has a running time of $O(log(k))$.

As outlined above, both operations on the Fenwick Tree having a running time which is logarithmic in $k$.
Additionally, there exist $n$ cookies, which means that the total running time for this solution is $O(n*log(k))$.
This is the case, as for each line of input, either `update` or `append` is called.
The preprocessing runs in $O(n)$ and is therefore linearly dominated by the linearrithmic running time of the second parse.
This running time is perfectly fine, as an algorithm with linearrithmic running time can compute problems where the input size $n$ is $n<=10^6$. // TODO: cite page 21 of the book

==== Median-heap
The idea is to maintain a median-heap.
A median-heap is a min-heap and a max-heap.
All elements less than the or equal to median are in the min-heap, while all elements in the max-heap are greateer than or equal to the median.
This solution simply uses the built-in python heap data structures to efficiently handle both pushing and popping.
The heap with the most elements will always contain the median value.

Insertion and popping from heaps both have a running time of $O(log(k))$, while checking the size is constant.

The total running time of the meadian-heap algorithm is the same, as the running time for the Fenwick tree solution.
The argument for this is exactly the same.
Since all operations performed on a median-heap are logarithmic, and these operations are run $n$ times, it follows that the running time must be $O(n*log(l))$

=== Worst Case Input
Since each operation is linearithmic, it means that a worst case input can not change this running time, it can only push the running time closer to the worst case.
Therefore, we must rely on pathological inputs, which force the data structure to its maximum capacity within the input parameters.

A worse case input, which is problematic for both Fenwick Trees and median-heaps is an input where all inserted diameters are distinct, and $n=600000$.
This is a worst case input, as each index of the array would contain one element.
This results in the array using as much space as possible, therefore also ensuring that the logarithmic operations take as much time as possible.
An example of such an input with $n=10$ instead of $n=600000$ would be.
```
1
2
3
4
5
#
#
#
#
#
```
