#import "@preview/touying:0.7.4": *
#import themes.simple: *

#show: simple-theme.with(aspect-ratio: "16-9")

= Algorithmic Problem Solving

== Leaky Pipes
=== Input
- edges: $1<=e<=10^3$
- edge capacity: $1<=c<=10^4$
- nodes: $ceil((1 + sqrt(1 + 4e)) / 2) <= m <= e + 1$

=== Time Complexity
- arithmetic: $O(E^2*log(c))$
- binary search: $O(E^2*log(c))$
- linear search: $O(c*E^2*log(c))$, not $O(c*E^2*log(c)^2)$

== Exchange Rates
=== Input
- days: $1<=n<=365$

=== Time Complexity
- day: $O(1)$
- total: $O(n)$

== Buzzwords
=== Input
- length: $1<=l<=10^3$

=== Time Complexity
- preprocessing: $O(l_n*log(l_n))$, not $O(n*log(l_n))$
  - $l_n = l$
- substring lookup: $O(l)$
- total: $O(l^2*log(l))$

== Cookie Selection
=== Input
- tasks: $1<=n<=600000$
- diameter: $1<=d<=300000000$

=== Time Complexity
- preprocessing: $O(m*log(m))$, not $O(n)$
- lookup: $O(log(m))$
- total: $O(n*log(m))$
