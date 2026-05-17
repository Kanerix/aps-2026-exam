#include <algorithm>
#include <cassert>
#include <iostream>
#include <limits>
#include <unordered_map>
#include <utility>
#include <vector>

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

long long minimizePipe(std::vector<std::unordered_map<std::size_t, int>> &graph,
                       std::size_t s, std::size_t t, std::size_t m_s,
                       std::size_t m_t, long threshold) {
    long long desired_max_flow = maxFlow(graph, s, t, threshold);

    long long current_max_flow = desired_max_flow;
    while (current_max_flow == desired_max_flow) {
        if (graph[m_s][m_t] == -1) {
            break;
        }

        --graph[m_s][m_t];
        current_max_flow = maxFlow(graph, s, t, threshold);
    }

    return graph[m_s][m_t] + 1;
}

int main() {
    std::size_t p{}, m{}, s{}, t{}, m_s{}, m_t{};
    std::cin >> p >> m >> s >> t >> m_s >> m_t;

    std::vector<std::unordered_map<std::size_t, int>> graph(m);
    int threshold = 0;
    for (std::size_t i = 0; i < p; ++i) {
        std::size_t u{}, v{};
        int c{};
        std::cin >> u >> v >> c;
        graph[u][v] = c;

        threshold = std::max(threshold, c);
    }

    long long max_flow = minimizePipe(graph, s, t, m_s, m_t, threshold);
    std::cout << max_flow << "\n";
}
