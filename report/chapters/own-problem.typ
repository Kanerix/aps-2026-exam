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

The actual problem, the user is tasked with is to figure out how much the broken pipe contributes to the overall flow of the graph.

== Accepted Solutions
All intended solutions use a variation of Ford-Fulkerson's max flow algorithm.
However, the Python and c++ solutions implement different variants.
The Python solutions implement the Edmonds-Karp algorithm, while the c++ solutions implement capacity scaling.
Both these algorithms are capable of finding the max flow of a graph in cubic time.

These algorithms avoid the less efficient implementations such as using DFS for graph traversal.
Using DFS for graph traversal can result in a graph traversal of $O(E*F_max)$, where $f_max$ is the max flow of the graph.

The capacity scaling solution has a running time of $O(E^2*log(c))$.
@laaksonen2018competitive[p. 185]
The capacity is set to a large value, such as the highest edge weight in the graph.
For each run of the path finding algorithm, this capacity is halved.
This running time is therefore given, as the edges of the graph er traversed $E^2$ times, while the capacity is halved for each run.
Edges are reversed $E^2$ times, as each run if DFS consumes $E$ edges, and consumes one edge by modifying the graph.
Additionally, DFS is run $E$ times in order to exhaust all edges of the graph.

The Edmonds-Karp max flow algorithm runs in $O(E^2*V)$.
This is given, as all edges are traversed through BFS.
The argument for $E^2$ is the same as the argument in capacity scaling.

=== Binary Search on Answer
The initial intended solution was to run a max flow algorithm once, to get the current max flow of the entire graph, including the leaky pipe.
Instead of breaking out of the search on equality a search hit, `hi` would be updated.
The only condition for breaking out of the search would be when lo became greater than `hi`.

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

Since each step in the binary search runs one instance of the max flow with capacity scaling, the resulting runtime for this solution is $O(log(c) * (E^2*log(c))) = O(E^2*log(c)^2)$.

=== Arithmetic
An alternative, more efficient solution, was found while attempting to create wrong solutions.
Instead of performing a binary search over the entire capacity of the pipe, it is possible to solve the problem with two runs of a max flow algorithm.

For the first run of max flow, the algorithm is run on the graph as is, resulting in the current flow of the graph.
Afterwards, the leaky pipe is removed from the graph completely and max flow is run again.
This will result in the max flow of the graph without the leaky pipe.
Afterwards, one can simply subtract the original max flow with the max flow of the graph with the leaky pipe removed.
This will result in the minimal contribution, which the leaky pipe can have to the flow in the graph.

This number is also the exact same value, as the smallest possible size the pipe can be while not decreasing the max flow of the graph.
This results in a running time of $O(E^2*log(c))$, as the constant factor $2$ is cast ignored in big O notation.

By intuition, this makes sense as well, as the smallest size the leaky pipe can be must be the same as the flow graph where the least amount of water flows through that specific pipe.

Since the python version use Edmonds-Karp, the running version is slightly different, namely $O(E^2V)$.
However, in practice, bot algorithms are efficient enough.

== Time Limit Exceeded Solutions
The time limit exceeded solutions are based on the Binary Search Solution. // refer to accepted
There exist two time limit exceeded solutions, and both perform a linear search on the answer.
One starts from the bottom and searches upwards, while another starts from the bottom and searches downwards.

Both solutions using linear search have a running time of $O(c*E^2*log(c)^2)$, as a linear search over the capacity of the pipe is performed, and for each step in the search, the capacity scaling max flow algorithm is performed.
This means that they quickly exceed the time limit, as the maximum pipe capacity is $10^4$, and $log(10^4) approx 9$, meaning such solutions are approximately $1000$ times slower than the intended Binary Search solution.

== Wrong Solutions
The wrong solution is based on a misunderstanding, which some of our peers experienced when they were shown the problem.
Namely, some people though that they were simply supposed to remove the broken pipe and calculate the max flow of the graph without the pipe.
This assumption is reasonable.
However, it fails to understand the actual problem, which requires the user to calculate the contribution of the broken pipe.

There exist no specific inputs to ensure that this solution fails, as it will fail all inputs.

== Run Time Exception Solution
There exists one runtime exception solution.
This solution is a solution, which fails to properly generate the residual graph.
It is based on the python solution, however, during the generation of the residual graph, which is done after the first run of BFS, reverse edges are not added, neither actively nor lazily.
This means that program encounters a runtime error, as it attempts to look up reverse edges, which have not been added.

Like with the wrong solution, there exist no specific input, which tests this, as this will fail all max flow inputs.

== Input Generation
All input generation occurred through the use of Python scripts, which can be found in the `generators/` directory of the Kattis Problem.
The most oft used input generator, `random` generates a completely random graph, based on the number of edges, and the maximum weight for edges.
This script was used to generate inputs of all sizes, creating 4 size categories, and 5 capacity categories, which resulted in 20 randomized input cases.
This ensured that the max flow implementation could handle graphs on either extreme.

Unfortunately, these scripts are not particularly sophisticated and were biased towards generating inputs where the solution was 0, meaning that a human had to cherry pick the inputs.
This means that the inputs aren't completely random, as some of them had to be regenerated multiple times.

=== Edge Case Inputs
Some edge case inputs also exist.
These inputs were generated by using the random input generator and then afterwards manually adjusting them to satisfy the edge cases, which they test.

The first edge case input was an input where there is only one edge, straight from the source to terminal.
Additionally, the broken pipe was also the edge between the source and terminal.
This meant that the algorithm had to exit after the very first run.

Another edge case which handled loops with the broken pipe was created.
This was created to ensure that the path finding algorithm handled loops correctly.

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
There exist two parameters which can be modified, edge count and max capacity, all other parameters are randomly chosen based on the constraints imposed by those parameters.
For example, the node count is randomly chosen within the possible number of nodes based on the edge count.

The lower limits are not particularly interesting, as they are set to be the absolute least values, where inputs can still be generated.

=== Edge Count
Edge count was set to $10^3$, as it was important, that the graph traversal part of the problem was difficult.
We tried with lower values which seemed to suffice, however, to ensure that the max flow algorithm was efficient and didn't include mistakes which caused wasteful computation, we decided to set this limit a bit higher.
This might also make Edmonds-Karp with DFS struggle to finish withing the running time, as the running time of this algorithm is heavily impacted by max flow of the entire graph.
We also compared this limit with other max flow problems on Kattis, and noticed that $10^3$ was within the same order of magnitude, which helped us deem this to be an acceptable upper limit.

=== Max Capacity
Max capacity was chosen to be $10^4$, as the intended solution was to perform binary search over the capacity of the pipe.

Initially, max capacity was set to $10^3$.
However, when it came to testing the time limit exceeded solution, it became apparent, that this parameter was set too low.
When `verifyproblem` was run, the time limit exceeded solutions would either finish within the time limit, or warn that the solution resided within a low margin of error.
Potentially, max capacity could have remained at $10^3$ if our input generation was more sophisticated and was able to generate more difficult graphs rather than only generating completely random graphs.

However, it seemed reasonable to simply increase the max capacity to $10^4$, as the intended solutions had no problems finishing within the time limit, while time limit exceed solutions instantly began exceeding the time limit.
