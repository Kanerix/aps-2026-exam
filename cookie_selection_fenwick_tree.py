import sys

def main():
    data = sys.stdin.read().split()
    
    vals = [int(x) for x in data if x != '#']
    coords = sorted(set(vals))
    rank = {v: i+1 for i, v in enumerate(coords)}
    m = len(coords)
    
    fenwickTree = [0] * (m + 1)
    
    def update(i, d):
        while i <= m:
            fenwickTree[i] += d
            i += i & -i
    
    def mid(k):
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
            r = mid(n // 2 + 1)
            out.append(coords[r - 1])
            update(r, -1)
            n -= 1
        else:
            update(rank[int(x)], 1)
            n += 1
    
    print('\n'.join(map(str, out)))

main()