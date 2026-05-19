= Own Kattis Problem - Leaky Pipes
The Kattis Problem "Leaky Pipes" is a max flow problem where the solution requires at least two runs of any max flow algorithm.
The problem statement for the issue is as follows.
```
Bob the plumber works in a massive hydroelectric power plant, where massive pipes direct the flow of water through the plant.
One pipe would flow into a manifold, which would then disperse the water into other pipes.
Eventually all pipes would exhaust back into the river.
This increased the water flow throughout the entire plant, and allowed for redirecting water during maintainace.

However, today, disaster had struck, one of the pipes had begun to leak and it was important for it to be replaced as soon as possible.
Bob found the piping and instrumentation diagram and quickly located the leaky pipe.
As he looked at the pipe, he found the size to be a bit awkward, as it seemed oodly large for the pipes around it.

Now Bob wants to use this oppurtunity to decrease the size of the pipe or completely remove it, if at all possible.
```
== Accepted Solutions
All intended solutions make use of Ford-Fulkerson's max flow algorithm.
The choice of Ford Fulkerson stems from the a desire to allow any max flow algorithm to solve the problem.
Therefore, it made sense to choose the least performant algorithm.
It would be more efficient to solve the problem with Edmonds-Karp or Dinic's algorithm, however, a problem designed for a more efficient algorithm might exclude less efficient algorithms.

Ford-Fulkerson does result in less efficient graph traversal, as the running time is now bound by the max flow, which can be sent through the graph.
This is due to the fact that DFS might not find a particularly efficient path to the terminal node, causing the algorithm to only increase max flow by one for each iteration.
If there was a desire to exclude Ford-Fulkerson from the accepted solutions, a worst case input as just described would need to be generated.

=== Binary Search on Answer
The initial intended solution was to run a max flow algorithm once, to get the current max flow of the entire graph, including the leaky pipe.
Instead of breaking out of the search on equality a search hit, hi would be updated.
The only condition for breaking out of the search would be when lo became greater than hi.

```cpp
while (hi > lo) {
    int mid = (hi - lo) / 2 + lo;
    graph[m_s][m_t] = mid;
    current_max_flow = maxFlow(graph, s, t, threshold);

    if (current_max_flow == desired_max_flow) {
        hi = mid;
    } else if (current_max_flow < desired_max_flow) {
        lo = mid + 1;
    }
}
```

This modified version of binary search does not have the normal break condition when a match is found, as multiple pipe capacities can result in the same max flow.
For this reason, the equality condition was updated to match greater than condition of normal binary search.
Likewise, the greater than condition was removed, as we are strictly searching for a pipe which is smaller than the current pipe, max flow can never increase.
Therefore, since the only way to break out of the binary search, is when there are no elements left to search, this binary search will always run in $O(log(c))$, where $c$ is the capacity of the pipe to be replaced.

Since each step in the binary search runs one instance of the Ford-Fulkerson's algorithm, the resulting runtime for this solution is $O(log(c) * (|E|*f_max))$, where $f_max$ is the max flow of the graph.

While a more efficient solution using Dinics would run in $O(log(n) * "DINICSRUNTIME")$. // FIXME: what is Dinics runtime

=== Arithmetic
An alternative, more efficient solution, was found while attempting to create wrong solutions.
Instead of performing a binary search over the entire capacity of the pipe, it is possible to solve the problem with two runs of a max flow algorithm.

For the first run of max flow, the algorithm is run on the graph as is, resulting in the current flow of the graph.
Afterwards, the leaky pipe is removed from the graph completely and max flow is run again.
This will result in the max flow of the graph without the leaky pipe.
Afterwards, one can simply subtract the original max flow with the max flow of the graph with the leaky pipe removed.
This will result in the minimal contribution, which the leaky pipe can have to the flow in the graph.

This number is also the exact same value, as the smallest possible size the pipe can be while not decreasing the max flow of the graph.
This results in a running time of $O(E*V^2)$, as the constant factor $2$ is cast ignored in big O notation.

By intuition, this makes sense as well, as the smallest size the leaky pipe can be must be the same as the flow graph where the least amount of water flows through that specific pipe.

== Time Limit Exceeded Solutions
The time limit exceeded solutions are based on the Binary Search Solution. // refer to accepted
There exist two time limit exceeded solutions, and both perform a linear search on the answer.
One starts from the bottom and searches upwards, while another starts from the bottom and searches downwards.

Both solutions using linear search have a running time of $O(c*|E|*f_max)$, as a linear search over the capacity of the pipe is performed, and for each step in the search, Ford-Fulkerson's algorithm is performed.
This means that they quickly exceed the time limit, as the maximum pipe capacity is $10^4$, and $log(10^4) approx 9$, meaning such solutions are approximately $1000$ times slower than the intended Binary Search solution.

== Wrong Solutions
// TODO

== Input Generation
All input generation occurred through the use of Python scripts, which can be found in the `generators/` directory of the Kattis Problem.
The most oft used input generator, `random` generates a completely random graph, based on the number of edges, and the maximum weight for edges.
This script was used to generate inputs of all sizes, creating 4 size categories, and 5 capacity categories, which resulted in 20 randomized input cases.
This ensured that the max flow implementation could handle graphs on either extreme.

Unfortunately, these scripts are not particularly sophisticated, and would often crash, likewise the generators were biased towards generating inputs where the solution was 1, meaning that a human had to cherry pick the inputs.
This means that the inputs aren't completely random, as some of them had to be regenerated multiple times. // TODO: consider if this is true

=== Time Limit Exceeded Input Generators
The time limit exceeded input generators are based on the `random` input generator, however, unlike random, they are not completely random.
Instead, they create pathological edge cases, unlikely to arise from random input generation.

The `linear_top` scrip generates a path to the terminal node where the first node is set to the max edge weight, $10^4$.
All proceeding edges have a weight of 1.
Otherwise, this graph is completely random.
This results in a graph where the least contribution to the maximum flow this path can have is $1$, ensuring top to bottom linear search is too slow.

The `linear_bottom` scrip generates a path to the terminal node where each edge on the path to the terminal node have a weight of $10^4$.
All other paths to the terminal node have a weight of $1$.
Otherwise, this graph is completely random.
This results in a graph where the least contribution to the maximum flow this path can have is $10^4$, ensuring bottom to top linear search is too slow.

== Parameters
There exist two parameters which can be modified, edge count and max capacity, all other parameters are randomly chosen based on the constraints imposed by those parameters. // FIXME: consider changing wording to something about only max weight and edge count being interesting
For example, the node count is randomly chosen within the possible number of nodes based on the edge count.

The lower limits are not particularly interesting, as they are set to be the absolute least values, where inputs can still be generated.

=== Edge Count
Edge count was set to $10^3$, as it was also important, that the graph traversal part was difficult.
We tried with lower values which seemed to suffice, however, to ensure that the max flow algorithm was efficient and didn't include mistakes which caused wasteful computation, we decided to set this limit a bit higher.
We also compared this limit with other max flow problems on Kattis, and noticed that $10^3$ was within the same order of magnitude, we deemed this to be an acceptable upper limit.

=== Max Capacity
Max capacity was chosen to be $10^4$, as the intended solution was to perform binary search over the capacity of the pipe.

Initially, max capacity was set to $10^3$.
However, when it came to testing the time limit exceeded solution, it became apparent, that this parameter was set too low.
When `verifyproblem` was run, the time limit exceeded solutions would either finish within the time limit, or warn that the solution resided within a low margin of error.
Potentially, max capacity could have remained at $10^3$ if our input generation was more sophisticated and was able to generate more difficult graphs rather than only generating completely random graphs.

However, it seemed reasonable to simply increase the max capacity to $10^4$, as the intended solutions had no problems finishing within the time limit, while time limit exceed solutions instantly began exceeding the time limit.

= Solved Problems

== Buzzwords
Buzzwords can be found at #link("https://open.kattis.com/problems/buzzwords").
Buzzwords is a longest substring problem, where the input consists of a set of lines.
Each line contains a combination of at least 1, and at most 1000 uppercase letters and spaces.
The final line of input is always an empty line, indicating the end of the input.

For each line, the output should contain a sequence of lines, each with an integer.
The first line should contain the number of repeated substrings of the length 1, excluding spaces, the second, the number of repeated substrings of length 2.
This should continue until no repeated substrings exist, at which point, a blank line should be printed.

=== Solution
There are multiple ways to solve this problem.
Our solution uses a rolling hash using a polynomial rolling hashing function.

Given the string $s$, the algorithm works by first choosing two arbitrarily large prime constants $A$ and $B$.
These prime constants are used to decrease likelihood of hashing collisions.
Afterwards, the prefix hashes for the entire string can be computed using the recursive relation
$
  h[0] = s[0] \
  h[k] = (h[k − 1] A + s[k]) % B
$
where $s[k]$ denotes the character value of the _kth_ letter of the string.

In addition to the prefix hashes, one must also calculate an array of power, which will be used to offset the prefix hashes.
The powers can be calculated through the recursive relation
$
  p[0] = 1 \
  p[k] = (p[k − 1] A) % B.
$
All prefix hashes and powers can be computed in $O(l)$ time, where $l$ is the length of the entire string.

With these two arrays calculated, it is now possible to calculate the hash value of any substring in $s$.
The hash value of the substring is defined by
  $
    h[a..b] = cases(
      (h[b] − h[a − 1]p[b − a + 1]) % B "if" a > 0,
      h[b] "if" a > 0
    )
  $
where $h[a..b]$ is the substring from index $a$ to index $b$.

The solution to Buzzwords uses this approach for hashing, as given $O(l)$ preprocessing, any substring hash value can be calculated in constant time.
In addition to this, one must count which word occurs most often.
This is done by storing the hash value for each substring of length $n$ in an array.
Afterwards, the hashes are sorted, ensuring that hashes are grouped together.
This sorting algorithm is language specific, but for most languages it is likely some algorithm, which sorts in $O(n log(l_h))$, where $l_h$ is the number of hashes.

At this point, the hashes are grouped together after hash values, and it is possible to iterate upon all hashes, and count which hash value occurs most often.
This can be done in $O(l_h)$, where $l_h$ is the length of the hashes array.
Since $l_h$ is bound by $l$, this means that $O(l) = O(l_h)$

Finally the substring hashing is performed $l$ times.
This means, that for each line $s$ of length $l$, the running time is $O(l^2 log(l_h))$.

Additionally, the input parameters state, that $l >= 1000$.
Since our solution runs in $O(l_h log(l_h) * l)$, which, even with the extra logarithmic factor finish well within the time limit.
This is the case, as solutions with a running time of $O(l^2)$ are expected to be able to solve problems with an input length of $l approx 5000$.

The only unknown factor here, is the number of lines, however, this is difficult to take into consideration, as not limit is imposed on it.

=== Worst Case Inputs
There exist two types of inputs which are particularly troubling for our solution.

==== Maximum Length Substrings
The first is an input, where each line just contains the same character repeated 1000 times.
This input forces the algorithm to compute the hash value for every substring, as every substring has at least one substring, which is the same.
Each line like this would ensure, that each line had to run the full $O(l^2 log(l))$ algorithm.

==== Hash Collisions
The other worst case input, which could be difficult for this problem is actually not a possible input.
Instead, it is an observation of the shortcomings of the rolling hash algorithm.
The polynomial hashing function is particularly vulnerable to hash collisions, especially if the input alphabet grows large enough.
Fortunately, the input alphabet of Buzzwords is only 26 letters, and the 2 arbitrarily chosen prime constants are very large, ensuring that the likelihood of hash collisions is extremely low.
It is in fact so low, that the buzzwords problem does not require any such resolution of hash collisions.
However, if it did, the solution would now be required to compare the string of all identical hashes.

Having to resolve conflicts would significantly increases the running time of the solution, as each each identical hash would also require comparing strings, which is linear in $l$.
This would result in the running time of the solution increasing to $O(l^3 log(l))$.

== Cookie Selection
Cookie Selection can be found at #link("https://open.kattis.com/problems/cookieselection").
The problem is about recieving cookies of some diameter, storing them, and, when requested, extracting the median cookie.
The input is at most 600 000 lines of either cookie size n, or # when extracting a cookie. 
n can be anything between 1 and 300 000 000. 
The output must be the diameter of each cookie when it is extracted, in the order of extraction. 

=== Solution
There are two solutions to this problem. The first one uses a fenwick tree, and the second uses a combination of a min-heap and a max-heap. 

==== Fenwick tree
The fenwick tree solution wants an array where the value at index i is the partial sum of cookies with the rank of i. 
This partial sums is: 
  $
    tree[k] = sumq(k − p(k)+1,k)
  $
where k − p(k)+1 is the lower bound, and k is the upper bound. This means that the partial sum at i cannot contain values higher than i. 

The solution uses a coordinate compression so as to not have 300 000 000 entries in the array. This works because we know there will be at most 600 000 cookies. 
This means that instead of having the value at i be cookie diameter, it is rank instead. 
The first parse process starts with collecting all input into an array $vals$ while ignoring any #. 
Afterwards, its moved to $vals$ while removing duplicates and sorting with pythons $timesort$. 
Lastly the dictionary rank is build. 

For the second parse, if the input is not a #, update(i, d) is called. 
Update starts at i (the rank), and increments the value at every index where the partial sum contains the cookie's rank. This is done through bit manipulation:
  $
    i += i & -i
  $
where i is the index, jumping upwards intil i > m, where m is the length of the tree.

If the input = #, mid(k) is called:
  $
    mid(n // 2 + 1)
  $
where we want the kth cookie, and n is incremented each time a cookie is added.
When searching, we set nxt to: 
  $
    x + 2^i
  $
where x starts at 0, and i starts as the bit length of m (roughly log(m)), where m is the length of the sorted distinct values $coords$.
In each iteration of the loop, we check if the partial sum at nxt is less than k; $fenwickTree[nxt] < k$ and if nxt is within bounds.  
If yes, we know the kth element cannot be in the range, and therefore set x = nxt to pass it, while subtracting from k the partial sum at nxt to make up for what is skipped (such that it functions as a prefix sum).
If no, we continue to the next iteration. After each iteration, i is decremented by 1, such that the search always narrows. Practically, this functions as a binary search. 
After the last iteration, we will have moved x as close to the median cookie rank as possible, without moving past it. Therefore we return x+1. 
$Coords$ is used for reverting the rank back to cookie diameter, and update(r, -1) is called to decrement the value at the appropriate ranks. 

==== Min-heap max-heap
The idea is to have both a min-heap and a max-heap, and have them constantly balanced such that the median value can always be accessed from popping the minheap.  
This solution simply uses the built-in python min-heap to efficiently handle both pushing and popping. 
The min-heap is reverted by inputting -n for input n, and -popping to revert it again, effectively making it a max-heap. 

Rebalancing is done a single time after each operation if nessecary. 


=== Running time discussion
==== Fenwick tree
The fenwick tree operations both have running time O(log m) where m is distinct cookie sizes, worst case m = N <= 600 000. 
Update: O(log m) as the flipping of the bit can only happen at most log m times in the tree.
Mid: O(log m) as it loops from $m.bit_length()$ down to 0
The first parse is O(N), where N is the total lines of input. 
Building the dict is O(N)
Coordinate compression is O(N log N) with timesort. 

==== Min-heap max-heap
Push: O(log N) 
Pop: O(log N)
Total: O(N log N) 

=== Worst case input
As the operations themselves are always O(log m) or O(log N), the worst case input is simply 600 000 lines. 
For the fenwick tree, an input potentially ordered in some way difficult for timesoft to handle could make things slightly slower. 

== Exchange Rates
Exchange Rates can be found at #link("https://open.kattis.com/problems/exchangerates").
Exchange Rates is a dynamic programming problem. The input consists of a number
of test cases, each beginning with $N$, the number of days that a crystal ball
can predict. $N$ lines follow, each containing a real number representing the
price of one U.S. dollar in Canadian dollars. The input is terminated by a test
case with $N = 0$.

For each test case, the output is the maximum amount of Canadian dollars it is
possible to hold at the end of the last predicted day, assuming one starts with
1000 CAD and may switch all of one's money between currencies on any subset of
the predicted days, in order. Each exchange is subject to a 3% commission, and
the resulting amount is rounded down to the nearest cent.

=== Solution
This problem is solved by maintaining two running values: $"best_cad"$, the
maximum amount of Canadian dollars one can hold at any point, and $"best_usd"$,
the maximum amount of U.S. dollars one can hold at any point. Initially,
$"best_cad" = 1000$ and $"best_usd" = 0$, given the fact that the starting
capital is 1000 CAD.

For each predicted day $i$ with exchange rate $r_i$ (CAD per USD), both values
are updated greedily:
$
  "best_cad" & = max("best_cad", floor("best_usd" times r_i times 0.97)) \
  "best_usd" & = max("best_usd", floor("best_cad" / r_i times 0.97))
$
The factor $0.97$ accounts for the 3% commission. The first update reflects
converting all USD to CAD at the current rate, and the second reflects
converting all CAD to USD. Because both updates use the values from before the
current day.

After processing all $N$ days, $"best_cad"$ holds the answer for the test case.

The intuition is that this greedy approach is correct because the optimal
strategy always consists of buying USD at a local minimum and selling at a local
maximum. By always tracking the best possible CAD and USD amounts reachable up
to the current day, the algorithm considers all such buy-and-sell combinations
without enumerating them explicitly.

Since each day requires only a constant number of operations, the running time
per test case is $O(N)$.
