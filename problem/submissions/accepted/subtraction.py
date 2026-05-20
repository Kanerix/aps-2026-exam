from copy import deepcopy


def bfs(s, t, parent, graph):
    visited = [False] * len(graph)
    queue = []
    queue.append((s, float("inf")))
    visited[s] = True

    while queue:
        u, flow = queue.pop(0)
        for v, cap in graph[u].items():
            if not visited[v] and cap > 0:
                parent[v] = u
                visited[v] = True
                max_flow = min(flow, cap)
                if v == t:
                    return max_flow

                queue.append((v, max_flow))

    return 0


def max_flow(s, t, graph):
    parent = [-1] * len(graph)
    max_flow = 0

    while True:
        path_flow = bfs(s, t, parent, graph)
        if path_flow == 0:
            break

        max_flow += path_flow

        v = t
        while v != s:
            u = parent[v]
            if u not in graph[v]:
                graph[v][u] = 0

            graph[u][v] -= path_flow
            graph[v][u] += path_flow
            v = u

    return max_flow


def main():
    p, m, s, t, m_s, m_t = input().split()
    graph: list[dict[int, int]] = [{} for _ in range(int(m))]
    for _ in range(int(p)):
        u, v, c = input().split()
        graph[int(u)][int(v)] = int(c)

    broken = deepcopy(graph)
    broken[int(m_s)][int(m_t)] = 0
    max_flow_with_broken_pipe = max_flow(int(s), int(t), graph)
    max_flow_without_broken_pipe = max_flow(int(s), int(t), broken)
    print(max_flow_with_broken_pipe - max_flow_without_broken_pipe)


main()
