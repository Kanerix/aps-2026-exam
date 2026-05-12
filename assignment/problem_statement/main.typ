#import "@preview/diagraph:0.3.7": *

= Home Renovation
Bob has recently been renovating his house, and he has finally gotten around to renovating his bathroom.
Bob started off by removing his old sink and installing a new one.
Now Bob has removed his toilet.

Bob found the documentation on how the pipes were installed and realized it resembled a series of tubes.
Water drains from the sink and toilet into one pipe each, the way the pipes are currently installed guarantees, that the pipe from the toilet is larger than the pipe from sink.
These pipes connect to a larger pipe system made up of pipes and manifolds, which eventually drain into the sewer.

Bob now wants to install a new pipe with the smallest capacity, while not decreasing total water flow to the sewer.
Therefore, Bob has asked you to figure out how small a waste pipe can be installed without decreasing water flow.

= Input
The first line of input contains 5 integers:
- $2<=p<=250$: the number of pipes
- $s_t$: the drain for the toilet, which Bob wants to minimize in size
- $s_s$: the drain for the sink ($s_s!=s_t$)
- $m_t$: the manifold which the toilet pipe connects to ($m_t!=s_s, m_t!=s_t$)
- $t$: the manifold which connects to the sewer ($t!=s_s, t!=s_t, t!= m_t$)
What follows is $p$ lines containing 3 integers $v$, $u$, $v!=u$, and $1<=c<=10^3$, indicating a pipe from manifold $v$ to manifold $u$ with a capacity of $c$.

It is guaranteed, that there always exists a pipe from $s_t$ to $m_t$, and that this is the only pipe originating from $s_t$

= Output
The output should contain exactly one integer, the minimum size of the waste pipe from the toilet, which does not impact the maximum water flow.
