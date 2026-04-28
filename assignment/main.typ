#import "@preview/diagraph:0.3.7": *

Bob has recently been renovating his house, and he has finally made it to
renovating his bathroom. Bob started off by removing the toilet, sink, and all
the bathroom tiles. But when Bob pulled up one of the tiles, he noticed that
there was a second waste pipe for a toilet there. Bob looked at how he wanted
the new bathroom to be designed, and realized that this second pipe was in the
perfect location for a toilet. Bob only had one concern, he wanted to maximize
the amount of water the toilet could exhaust.

Bob had found documentation on how the pipe were installed and realized it
resembled a series of tubes. This mean that a pipe would connect to a manifold
and distribute water into different pipes, as this allowed for increased water
flow. To figure this out, Bob has asked you for help figuring out which pipe can
carry the most water to the sewer.

= Input
The first line of input contains 5 integers $2<=n<=250$ pipe connections,
$1<=m<=n(n-1)$ manifolds, $2<=s_1<=250$ and $2<=s_2<=250$ the manifolds which
the two pipes connect to, and the manifold which connects the pipes to the sewer
$2<=t<=250$, $s!=t$. What follows is $m$ lines containing 3 integers
$2<=v<=250$, $2<=u<=250$, $v!=$, and $1<=c<=10^3$, indicating a pipe from
manifold $v$ to manifold $m$ with a capacity of $c$.

= Output
The output should be exactly one line containing the string:
- "original", if the original waste pipe can carry the most water
- "new" if the newly discovered waste pipe can carry the most water
- "either" if the waste pipes can carry the same amount of water.

#raw-render(
  ```dot
  digraph {
    s_1 -> m_1 [label=4, weight=4]
    m_1 -> m_2 [label=4, weight=4]
    m_2 -> t [label=6, weight=6]
    s_2 -> m_2 [label=4, weight=4]
  }```,
)

#raw-render(
  ```dot
  digraph {
    s_1 -> m_1 [label=10, weight=10]
    m_1 -> m_2 [label=4, weight=4]
    m_2 -> m_3 [label=6, weight=6]
    m_3 -> m_1 [label=10, weight=10]
    m_3 -> t [label=3, weight=3]
    s_2 -> m_3 [label=8, weight=8]
  }```,
)

#raw-render(
  ```dot
  digraph {
    s_1 -> m_1 [label=100,weight=100]
    m_1 -> m_2 [label=40,weight=40]
    m_1 -> m_3 [label=40,weight=40]
    m_2 -> m_3 [label=20,weight=20]
    m_3 -> m_1 [label=45,weight=45]
    m_3 -> t [label=180,weight=180]
    s_2 -> m_4 [label=100,weight=100]
    m_4 -> m_1 [label=20,weight=20]
    m_4 -> t [label=60,weight=60]
  }```,
)
