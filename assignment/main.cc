#include <algorithm>
#include <cassert>
#include <iostream>
#include <limits>
#include <unordered_map>
#include <utility>
#include <vector>

const int CONNECTION_S = 2;

bool dfsMaxFlow(std::vector<std::unordered_map<std::size_t, int>> &graph,
                std::vector<bool> &visited,
                std::vector<std::pair<std::size_t, std::size_t>> &res,
                std::size_t u, std::size_t t, long threshold) {
    assert(visited.size() == graph.size());

    if (visited[u]) {
        return false;
    }
    visited[u] = true;

    for (const auto &[v, cap] : graph[u]) {
        if (cap > threshold) {
            if (v == t) {
                res.push_back({u, v});
                return true;
            } else if (dfsMaxFlow(graph, visited, res, v, t, threshold)) {
                res.push_back({u, v});
                return true;
            }
        }
    }
    return false;
}

std::vector<std::pair<std::size_t, std::pair<std::size_t, int>>>
flowGraph(std::vector<std::unordered_map<std::size_t, int>> &orig,
          std::vector<std::unordered_map<std::size_t, int>> &mod) {
    std::vector<std::pair<std::size_t, std::pair<std::size_t, int>>>
        flow_graph{};
    for (std::size_t u = 0; u < orig.size(); ++u) {
        for (const auto &[v, cap] : orig[u]) {
            int edge_flow = orig[u][v] - mod[u][v];
            if (edge_flow > 0) {
                flow_graph.push_back({u, {v, edge_flow}});
            }
        }
    }
    return flow_graph;
}

std::vector<std::unordered_map<std::size_t, int>> generateReverseEdges(
    const std::vector<std::unordered_map<std::size_t, int>> &orig) {
    auto graph = orig;
    for (std::size_t u = 0; u < orig.size(); ++u) {
        for (const auto &[v, cap] : orig[u]) {
            if (graph[v].find(u) == graph[v].end()) {
                graph[v][u] = 0;
            }
        }
    }

    return graph;
}

void addSuperSource(std::vector<std::unordered_map<std::size_t, int>> &graph,
                    std::size_t s1, std::size_t s2) {
    std::size_t super_source_idx = graph.size() - 1;
    graph[super_source_idx][s1] = std::numeric_limits<int>::max();
    graph[super_source_idx][s2] = std::numeric_limits<int>::max();
}

long long maxFlow(const std::vector<std::unordered_map<std::size_t, int>> &orig,
                  std::size_t s, std::size_t t, long threshold) {
    long long max_flow = 0;

    auto graph = generateReverseEdges(orig);

    std::vector<std::pair<std::size_t, std::size_t>> res{};
    std::vector<bool> visited{};
    while (true) {
        res.clear();
        visited.assign(graph.size(), false);

        bool found_path = dfsMaxFlow(graph, visited, res, s, t, threshold);
        if (!found_path) {
            if (threshold > 0) {
                threshold /= 2;
                continue;
            } else {
                return max_flow;
            }
        }

        int path_flow = std::numeric_limits<int>::max();
        for (const auto &[u, v] : res) {
            path_flow = std::min(path_flow, graph[u][v]);
        }

        for (const auto &node : res) {
            graph[node.first][node.second] -= path_flow;
            graph[node.second][node.first] += path_flow;
        }
        max_flow += path_flow;
    }
}

long long minimizePipe(std::vector<std::unordered_map<std::size_t, int>> &orig,
                       std::size_t super_s, std::size_t modifiable_s,
                       std::size_t t, long threshold) {

    long long desired_max_flow = maxFlow(orig, super_s, t, threshold);

    int hi = orig[modifiable_s][CONNECTION_S];
    int lo = 1;
    long long current_max_flow{};
    while (hi > lo) {
        int mid = (hi - lo) / 2 + lo;
        orig[modifiable_s][CONNECTION_S] = mid;
        current_max_flow = maxFlow(orig, super_s, t, threshold);

        if (current_max_flow == desired_max_flow) {
            hi = mid;
        } else if (current_max_flow < desired_max_flow) {
            lo = mid + 1;
        }
    }

    return hi;
}

int main() {
    std::size_t n{}, m{}, modifiable_s{}, other_s{}, t{};
    std::cin >> n >> m >> modifiable_s >> other_s >> t;

    std::vector<std::unordered_map<std::size_t, int>> graph(
        n + 1); // n + 1 for super source
    int threshold = 0;
    for (std::size_t i = 0; i < m; ++i) {
        std::size_t u{}, v{};
        int c{};
        std::cin >> u >> v >> c;
        graph[u][v] = c;

        threshold = std::max(threshold, c);
    }

    addSuperSource(graph, modifiable_s, other_s);
    long long max_flow = minimizePipe(graph, n, modifiable_s, t, threshold);
    std::cout << max_flow << "\n";
}
