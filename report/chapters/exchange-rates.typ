== Exchange Rates - kasjo
Exchange Rates can be found at #link("https://open.kattis.com/problems/exchangerates").
Exchange Rates is a dynamic programming problem.
The input consists of a number of test cases, each beginning with $1<d<=365$, the number of days that a crystal ball can predict.
$d$ lines follow, containing a real number representing the price of one U.S. dollar in Canadian dollars.
The input is terminated by a test case where $d=0$.

Each test case requires finding the maximum amount of Canadian dollars possible at the end of the last predicted day.
You start with 1000 CAD.
You may switch all of your money between currencies on any subset of the predicted days, in order.
Each exchange is subject to a 3% commission, and the resulting amount is rounded down to the nearest cent.

The output for each test case should contain a single real number, the maximum amount of CAD you can hold after $d$ days.

=== Solution
This problem can be considered a very small dynamic programming problem, even if the solution looks deceptively greedy, as there are only two subproblems to solve; exchanging, or not exchanging.

This problem is solved by maintaining two running values: $"cad"_i$, the maximum amount of Canadian dollars one can hold at any point $i$, and $"usd"_i$, the maximum amount of U.S. dollars one can hold at any point $i$.
Initially, $"cad"_0 = 1000$ and $"usd"_0 = 0$, given that the starting capital is $1000$ CAD.

For each predicted day $i$ with exchange rate $r_i$ (CAD per USD), both values are updated greedily:
$
  "cad"_i = max("cad"_(i-1), floor("usd"_(i-1) * r_i * 0.97)) \
  "usd"_i = max("usd"_(i-1), floor("cad"_(i-1) / r_i * 0.97))
$
The factor $0.97$ accounts for the 3% commission.
The first update reflects converting all USD to CAD at the current rate, and the second reflects converting all CAD to USD.
This uses the best result for the previous day to calculate whether you would gain money from converting all your money from CAD to USD or vice versa.
Both CAD and USD are stored, as this allows us to "regret" a given exchange if it later turns out not exchanging would have yielded better results.

Additionally, this is where they dynamic programming comes into play.
The algorithm solves two problems at each step "at day $i$, how many USD/CAD could I have".
The value for day $i$ is then used to compute the value day $i+1$.
A greedy algorithm would instead commit to either USD or CAD based on the results of the current day $i$.
After processing all $d$ days, $"cad"_d$ holds the answer for the test case.

The intuition is that this approach is correct because the optimal strategy always consists of buying USD at a local minimum and selling at a local maximum.
By always tracking the best possible CAD and USD amounts reachable up to the current day $i$, the algorithm considers all such buy-and-sell combinations without enumerating them explicitly.

The result of each day can be computed in a constant number of operations, $O(1)$.
Likewise, there exist $d$ days to days to compute, therefore the running time of each test case must be $O(d)$.
With this running time, it is safe to conclude, that this algorithm can solve this problem withing the time limit, as algorithms with $O(n)$ running times can solve problems with inputs of this size $10^6$.
@laaksonen2018competitive[p. 21]
The only concern is how many test cases exist in the problem, but as this parameter is not given in the problem statement, it cannot be included in the analysis.

=== Worst Case Inputs
Given the input parameters and the linear time complexity, there exist no worst case inputs for this problem.
