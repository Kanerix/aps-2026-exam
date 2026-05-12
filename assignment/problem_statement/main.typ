#import "@preview/diagraph:0.3.7": *

= Home Renovation
Bob has recently been renovating his house, and he has finally gotten around to renovating his bathroom.
Bob started off by removing his old sink and installing a new one.
Now Bob has removed his toilet.
However, before installing a new toilet, Bob realized that he could install a new waste pipe and potentially not decrease the water flow from his bathroom.

Bob found the documentation on how the pipes were installed and realized it resembled a series of tubes.
The toilet and sink drains in his house would connect to pipes, which would connect to a manifold, which would then distribute the water through the system for increased flow, as this allowed for increased water flow.
Bob is unable to install a new waste pipe for the sink, as he has already installed a new sink.
However, Bob is able to install a new waste pipe for the toilet.
Therefore, Bob has asked you to figure out how small a waste pipe can be installed without decreasing water flow.

= Input
The first line of input contains 6 integers:
- $2<=p<=250$: the number of pipes
- $1<=m<=p(p-1)$: the number of manifolds
- $0<=s_t<=250$: the drain for the toilet, which Bob wants to minimize in size
- $0<=s_s<=250$: the drain for the sink ($s_s!=s_t$)
- $0<=m_t<=250$: the manifold which the toilet pipe connects to ($m_t!=s_s, m_t!=s_t$)
- $0<=t<=250$: the manifold which connects to the sewer ($t!=s_s, t!=s_t, t!= m_t$)
What follows is $p$ lines containing 3 integers $2<=v<=250$, $2<=u<=250$, $v!=u$, and $1<=c<=10^3$, indicating a pipe from manifold $v$ to manifold $u$ with a capacity of $c$.

= Output
The output should contain exactly one integer, the minimum size of the waste pipe from the toilet, which does not impact the maximum water flow.
