#This solution implements a "median-heap" by combining a max-heap and min-heap
import heapq
import sys


lowMaxHeap = []
highMinHeap = []

for line in sys.stdin:
    line = line.strip()
    if line == '#':
        popValue = heapq.heappop(highMinHeap)
        print(popValue)

        #rebalance
        if len(highMinHeap) < len(lowMaxHeap):
            heapq.heappush(highMinHeap, -heapq.heappop(lowMaxHeap))
    else:
        n = int(line)
        if highMinHeap and n >= highMinHeap[0]:
            heapq.heappush(highMinHeap, n)
        else:
            heapq.heappush(lowMaxHeap, -n) #negative to reverse max-heap to min-heap


        #rebalance
        if len(highMinHeap) > len(lowMaxHeap) + 1:
            heapq.heappush(lowMaxHeap, -heapq.heappop(highMinHeap))
        elif len(lowMaxHeap) > len(highMinHeap):
            heapq.heappush(highMinHeap, -heapq.heappop(lowMaxHeap))

