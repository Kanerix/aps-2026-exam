== Buzzwords - mnni
Buzzwords can be found at #link("https://open.kattis.com/problems/buzzwords").
Buzzwords is a longest substring problem, where the input consists of a set of lines.
Each line contains a combination of at least $1$, and at most $1000$ uppercase letters and spaces.
The final line of input is always an empty line, indicating the end of the input.

For each line, the output should contain a sequence of lines, each with an integer.
The first line should contain the number of repeated substrings of the length $1$, excluding spaces, the second line, the number of repeated substrings of length 2.
This should continue until no repeated substrings exist, at which point, a blank line should be output.

=== Solution
There are multiple ways to solve this problem.
Our solution uses a rolling hash with a polynomial hashing function.

Given the string $s$, the algorithm works by first choosing two arbitrarily large prime constants $A$ and $B$.
These prime constants are used to decrease the likelihood of hashing collisions.
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
    h[b] "if" a = 0
  )
$
where $h[a..b]$ is the substring from index $a$ to index $b$.
The solution to Buzzwords uses this approach for hashing, as given $O(l)$ preprocessing, the hash value of any substring can be calculated in constant time.

The problem statement also requires, a count of which word occurs most often.
This is done by storing the hash value for each substring of length $n$ in an array.
Afterwards, the hashes are sorted, ensuring that hashes are grouped together.
This sorting algorithm is language specific, but for most languages it is likely some algorithm, which sorts in $O(n log(h_n))$, where $h_n$ is the number of hashes.

At this point, the hashes are grouped together after hash values, and it is possible to iterate upon all hashes, and count which hash value occurs most often.
This can be done in $O(l_n)$, where $l_n$ is the length of the hashes array.
Since $l_n$ is bounded by $l$, it follows that $O(l) = O(l_n)$

This process is repeated until for each length $1,2,...,l-1,l$ or until there exist no matching substrings of the length $n$.
This means, that for each line $s$ of length $l$, the running time is $O(l^2*log(l))$.
This time complexity is given, as each substring length query runs in $O(l*log(l))$, as it is linearly dominated by the sorting step and substring length queries are performed $l$ times.

Additionally, the input parameters state, that $l >= 1000$.
Since our solution runs in $O(l^2*log(l))$, which, even with the extra logarithmic factor finish well within the time limit.
This is the case, as solutions with a running time of $O(n^2)$ are expected to be able to solve problems with an input length of $l approx 5000$.
@laaksonen2018competitive[p. 21]

The only unknown factor here, is the number of lines, however, this is impossible to take into consideration, as not limit is imposed on it.

=== Worst Case Inputs
There exist two types of inputs which are particularly troubling for our solution.

==== Maximum Length Substrings
The first is an input, where each line just contains the same character repeated 1000 times.
This input forces the algorithm to compute the hash value for every substring, as every substring has at least one substring, which is the same.
Each line of input like this would ensure, that the algorithm would not be able to exit early, and would run the full $O(l^2 log(l))$.

==== Hash Collisions
The other worst case input, which could be difficult for this problem is actually not a possible input.
Instead, it is an observation of the shortcomings of the rolling hash algorithm.
The polynomial hashing function is particularly vulnerable to hash collisions, especially if the input alphabet grows large enough.
Fortunately, the input alphabet of Buzzwords is only 26 letters.
Since the 2 arbitrarily chosen prime constants are very large, the likelihood of hash collisions is extremely low.
It is in fact so low, that the buzzwords problem does not require any such resolution of hash collisions.
However, if it did, the solution would now be required to compare the string of all identical hashes.

Having to resolve conflicts would significantly increases the running time of the solution, as each each identical hash would also require comparing strings, which is linear in $l$.
This would result in the time complexity of the solution rising to $O(l^3 log(l))$.

