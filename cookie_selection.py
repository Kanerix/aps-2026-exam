import heapq
import sys


maxHeap = []
minHeap = []

for line in sys.stdin:
    line = line.strip()
    if line == '#':
        popValue = heapq.heappop(minHeap)
        print(popValue)

        #rebalance
        if len(minHeap) < len(maxHeap):
            heapq.heappush(minHeap, -heapq.heappop(maxHeap))
    else:
        n = int(line)
        if minHeap and n >= minHeap[0]:
            heapq.heappush(minHeap, n)
        else:
            heapq.heappush(maxHeap, -n) #negative to reverse max-heap to min-heap


        #rebalance
        if len(minHeap) > len(maxHeap) + 1:
            heapq.heappush(maxHeap, -heapq.heappop(minHeap))
        elif len(maxHeap) > len(minHeap):
            heapq.heappush(minHeap, -heapq.heappop(maxHeap))