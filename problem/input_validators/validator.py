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
source = int(parts[2])
terminal = int(parts[3])
manifold_s = int(parts[4])
manifold_t = int(parts[5])

if pipes < 1 or pipes > 1000:
    exit_error("Pipes must be in the interval 1<=p<=1000")
if source == terminal:
    exit_error("Source and terminal node may not be the same")
if manifold_s == terminal:
    exit_error("Broken pipe source and terminal node may not be the same")
if manifold_s == manifold_t:
    exit_error("Broken pipe source and broken pipe terminal node may not be the same")
if math.ceil((1 + math.sqrt(1 + 8 * pipes)) / 2) > manifolds or pipes + 1 < manifolds:
    exit_error("Either too many or to few sinks")


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

    if u == v:
        exit_error("u and v may not be the same")
    if c < 1 or c > 10000:
        exit_error("Capacity must be in the interval 1<=c<=10000")


if sys.stdin.readline():
    exit_error("Trailing content")

sys.exit(42)
