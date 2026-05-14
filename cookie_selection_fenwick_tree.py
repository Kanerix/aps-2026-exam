#This solution uses a fenwick tree 
#The rank(index but compressed) of the array 'fenwickTree' correlates to the cookie diamater, and the value is the partial sum of cookies over a range of ranks
#As the possible cookie sizes are greater than the actual total cookie input, we read data to get the size and a dictionary diameter -> rank
#Then read it again while putting cookies into and extracting cookies from fenwickTree

import sys

def main():
    data = sys.stdin.read().split()
    
    vals = [int(x) for x in data if x != '#']
    coords = sorted(set(vals))
    rank = {v: i+1 for i, v in enumerate(coords)}
    m = len(coords)
    
    fenwickTree = [0] * (m + 1)
    
    def update(i, d=1):
        while i <= m:
            fenwickTree[i] += d
            i += i & -i
    
    def kth(k):
        x = 0
        for i in range(m.bit_length(), -1, -1):
            nxt = x + (1 << i)
            if nxt <= m and fenwickTree[nxt] < k:
                k -= fenwickTree[nxt]
                x = nxt
        return x + 1
    
    n = 0
    out = []
    for x in data:
        if x == '#':
            r = kth(n // 2 + 1)
            out.append(coords[r - 1])
            update(r, -1)
            n -= 1
        else:
            update(rank[int(x)])
            n += 1
    
    print('\n'.join(map(str, out)))

main()