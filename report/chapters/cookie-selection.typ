== Cookie Selection
Cookie Selection can be found at #link("https://open.kattis.com/problems/cookieselection").
The problem is about receiving cookies of some diameter $d$, storing them, and, when requested, extracting the median cookie.
The input is at most $1 <= n <= 600000$ lines of either cookie size $d$, or "\#" which means you must print the size of the median cookie and stop tracking it.
The value of $d$ must be in the interval $1 <= d <= 300000000$.
The output must be the diameter of each cookie when it is extracted, in the order of extraction.

=== Solution & Time Complexity
There are multiple solutions to this problem.
The following includes two potential solutions.
The first one uses a Fenwick tree, and the second uses a combination of a min-heap and a max-heap, henceforth referred to as a median-heap.

==== Fenwick Tree
The Fenwick Tree solution is backed by an array where the value at index $k$ is the partial sum of values prior to $k$.
This partial sums is defined as
$
  "tree"[k] = "sum"_q(k − p(k)+1, k)
$
where $p(k)$ is the larges power of 2, which divides $k$.
$"sum"_q(a,b)$ defines the value sum of values with the range $a$ ending at $b$.
Since $a$ is defined by $p(k)$, the ranges which $"sum"_q$ cover increase, as the index value $b$ does.

The solution compresses the diameters of the cookies, as this avoids storing an array of length $300000000$ in memory.
Instead, cookie diameter is compressed into ranks, meaning, for example, that the least cookie diameter has rank 1.
#footnote[Fenwick Trees start at index to ease implementation]
This is done by first parsing the entire input, skipping "\#" characters and storing them in a list.
Afterwards, this list is sorted, and finally they are stored in a dictionary, where diameter $d$ point to the corresponding rank.
With this in place, the Fenwick tree can be constructed, where the backing array contains an index for each rank.
This allows us to perform queries on the cookie weights in the Fenwick Tree, which uses an index from 1 to $n$.

This initial preprocessing runs in $O(n*log(n))$, as it is linearly dominated by the sorting step.

Afterwards, the input is processed again.
If the input line is not the "\#" character, `update(k, d)` is called.
Update starts at $k$ (the rank), and increments the value at every index after, which uses $k$ to define their partial sum.
In practice, this means it traverses up the tree from the index of $k$.
This is done through the bitwise operation $k =+ (k & -k)$, which moves $k$ to the next moves to the next index for the cumulative sum originating fro $k$.
The update traversal always increases in size covered, doubling each step, as the value of $p(k)$ as $k$ does.
Since the operation updates accesses $O(log(k))$ items, `update` has a time complexity of $O(log(n))$.

If the input line is the "\#" character, `mid(k)` is called.
`mid(k)` finds the cookie rank where the cumulative sum is $"rank" >= k$.
This is done by performing a binary search over the tree to find the specific $k$, which satisfies the above condition.
This rank is then looked up to find the original cookie diameter.
Finally, the cookie with rank $k$ is decreased by one.
This is done as the cookie has been "removed" from the packing facility.

Like with `update`, the value, which `mid` accesses increase, as the value of $p(k)$ does, resulting in a time complexity of $O(log(k))$

As outlined above, both operations on the Fenwick Tree having a running time which is logarithmic in $k$.
Additionally, there exist $n$ cookies, which means that the total running time for this solution is $O(n*log(k))$.
This is the case, as for each line of input, either `update` or `append` is called.
The preprocessing runs in $O(n)$ and is therefore linearly dominated by the linearithmic running time of the second parse.
This running time is perfectly fine, as an algorithm with linearithmic running time can compute problems where the input size $n$ is $n<=10^6$.
@laaksonen2018competitive[p. 21]

==== Median Heap
A median heap is implemented through a min heap and a max heap.
All elements less than the or equal to the median value are in the min heap, while all elements in the max-heap are greater than or equal to the median.
This solution simply uses the built-in python heap data structures to efficiently handle both pushing and popping.
The heap with the most elements will always contain the median value.

Insertion and popping from heaps both have a running time of $O(log(k))$, while checking the size is constant.

The total running time of the median heap algorithm is the same, as the running time for the Fenwick tree solution.
The argument for this is exactly the same.
Since all operations performed on a median heap are logarithmic, and these operations are run $n$ times, it follows that the running time must be $O(n*log(l))$

=== Worst Case Input
Since each operation is linearithmic, it means that a worst case input can not change the time complexity of the solution, it can only push the running time closer to the max.
Therefore, we must rely on pathological inputs, which force the data structure to operate at their maximum capacity within the input parameters.

A worse case input, which is problematic for both Fenwick Trees and median heaps is an input where all inserted diameters are distinct, and $n=600000$.
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
