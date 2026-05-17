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
All intended solutions make use of Edmonds Karp max flow algorithm with DFS for path finding. // FIXME: is it even spelled like this?
The choice of Edmonds Karp stems from the fact that Edmonds Karp's algorithm run in $O(E*V^2)$, which is an acceptable running time for this problem.
Additionally, it also avoids the more performant yet difficult implementations of Max Flow such as Dinics // FIXME: how do you spell this?

Moreover, DFS was chosen over BFS, as it is simple to implement in a recursive manner, and the modifications required to generate a residual graph are simple to add.
Like with the chose flow algorithm, BFS would also be able to solve this, it is a simple matter of preference.

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

Since each step in the binary search runs one instance of the Edmonds Karp algorithm, the resulting runtime for this solution is $O(log(c) * (E*V^2))$.

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

Both solutions using linear search have a running time of $O(c*E*V^2)$, as a linear search over the capacity of the pipe is performed, and for each step in the search, Edmonds Karp algorithm is performed.
This means that they quickly exceed the time limit, as the maximum pipe capacity is $10^4$, and $log(10^4) ~= 9)$, meaning such solutions are approximately $1000$ times slower than the intended Binary Search solution.

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

