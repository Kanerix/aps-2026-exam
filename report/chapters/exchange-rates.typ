== Exchange Rates - kasjo
Exchange Rates can be found at #link("https://open.kattis.com/problems/exchangerates").
Exchange Rates is a dynamic programming problem.
The input consists of a number of test cases, each beginning with $N$, the number of days that a crystal ball can predict.
$N$ lines follow, each containing a real number representing the price of one U.S. dollar in Canadian dollars.
The input is terminated by a test case with $N = 0$.

For each test case, the output is the maximum amount of Canadian dollars it is possible to hold at the end of the last predicted day, assuming one starts with 1000 CAD and may switch all of one's money between currencies on any subset of the predicted days, in order.
Each exchange is subject to a 3% commission, and the resulting amount is rounded down to the nearest cent.

=== Solution
This problem is solved by maintaining two running values: $"best_cad"$, the maximum amount of Canadian dollars one can hold at any point, and $"best_usd"$, the maximum amount of U.S. dollars one can hold at any point.
Initially, $"best_cad" = 1000$ and $"best_usd" = 0$, given the fact that the starting capital is 1000 CAD.

For each predicted day $i$ with exchange rate $r_i$ (CAD per USD), both values are updated greedily:
$
  "best_cad" & = max("best_cad", floor("best_usd" times r_i times 0.97)) \
  "best_usd" & = max("best_usd", floor("best_cad" / r_i times 0.97))
$
The factor $0.97$ accounts for the 3% commission. The first update reflects converting all USD to CAD at the current rate, and the second reflects converting all CAD to USD.
Because both updates use the values from before the current day.

After processing all $N$ days, $"best_cad"$ holds the answer for the test case.

The intuition is that this greedy approach is correct because the optimal strategy always consists of buying USD at a local minimum and selling at a local maximum.
By always tracking the best possible CAD and USD amounts reachable up to the current day, the algorithm considers all such buy-and-sell combinations without enumerating them explicitly.

Since each day requires only a constant number of operations, the running time per test case is $O(N)$.
