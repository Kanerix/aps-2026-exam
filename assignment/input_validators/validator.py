import sys
import math


def exit_error(message):
    print(message, file=sys.stderr)
    sys.exit(43)


def check_leading_zero(item):
    if len(item) > 1 and item.startswith("0"):
        exit_error("Items may bo start with 0")


line = sys.stdin.readline()

parts = line.split()
if len(parts) != 6:
    exit_error("Expected exactly 6 items")

for part in parts:
    check_leading_zero(part)

pipes = int(parts[0])
manifolds = int(parts[1])
source1 = int(parts[2])
source2 = int(parts[3])
manifold_s1 = int(parts[4])
terminal = int(parts[5])

if pipes < 2 or pipes > 1000:
    exit_error("Pipes should be in the interval 2<=p<=1000")
if source1 == source2:
    exit_error("Toilet source and sink source may not be the same")
if source1 == terminal:
    exit_error("Toilet source and terminal node may not be the same")
if source1 == manifold_s1:
    exit_error("Toilet source and manoifold connection may not be the same")
if source2 == terminal:
    exit_error("Sink source and terminal node may not be the same")
if source2 == manifold_s1:
    exit_error("Sink source and manifold connect may not be the same")
if math.ceil((1 + math.sqrt(1 + 8 * pipes)) / 2) > manifolds or pipes + 1 < manifolds:
    exit_error("Either too many or to few sinks")
if manifold_s1 == terminal:
    exit_error("Manifold connection and terminal node may bot be the same")


source1_count = 0
source2_count = 0
for i in range(pipes):
    line = sys.stdin.readline()

    if not line:
        exit_error(f"Expected {pipes} pipes")

    parts = line.split()
    if len(parts) != 3:
        exit_error("Expected 3 items")

    for part in parts:
        check_leading_zero(part)
    u = int(parts[0])
    v = int(parts[1])
    c = int(parts[2])

    if u == source1:
        source1_count += 1
    if u == source2:
        source2_count += 1

    if u == v:
        exit_error("u and v may not be the same")
    if v == source1:
        exit_error("No path may lead to toilet")
    if v == source2:
        exit_error("No path may lead to sink")
    if c < 1 or c > 10000:
        exit_error("Capacity must be in the interval 1<=c<=10000")
    if source1_count > 1:
        exit_error("Only one path may originate from the toilet")
    if source2_count > 1:
        exit_error("Only one path may originate from the sink")


if sys.stdin.readline():
    exit_error("Trailing content")

sys.exit(42)
