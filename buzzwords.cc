#include <iostream>
#include <string>
#include <string_view>
#include <vector>

const long long A = 911382323;
const long long B = 972663749;

std::vector<long long> getPrefixHashes(std::string_view str) {
    std::vector<long long> prefix_hashes(str.length());
    prefix_hashes[0] = str[0] - 'A';
    for (std::size_t i = 1; i < prefix_hashes.size(); ++i) {
        prefix_hashes[i] = (prefix_hashes[i - 1] * A + (str[i] - 'A')) % B;
    }
    return prefix_hashes;
}

std::vector<long long> getPowers(std::vector<long long> &prefix_hashes) {
    std::vector<long long> powers(prefix_hashes.size());
    powers[0] = 1;
    for (std::size_t i = 1; i < prefix_hashes.size(); ++i) {
        powers[i] = (powers[i - 1] * A) % B;
    }
    return powers;
}

int countDuplicateSubstrings(int len, std::string_view str,
                             std::vector<long long> &prefix_hashes,
                             std::vector<long long> &powers) {
    std::vector<long long> hashes(str.length() - static_cast<std::size_t>(len) +
                                  1);

    hashes[0] = prefix_hashes[static_cast<std::size_t>(len) - 1];
    for (std::size_t i = 1; i < hashes.size(); ++i) {
        std::size_t end_idx = i + static_cast<std::size_t>(len) - 1;
        hashes[i] = (prefix_hashes[end_idx] -
                     prefix_hashes[i - 1] * powers[end_idx - i + 1]) %
                    B;
        if (hashes[i] < 0) {
            hashes[i] += B;
        }
    }

    std::sort(hashes.begin(), hashes.end());

    int max = 1;
    int count = 1;
    for (std::size_t i = 1; i < hashes.size(); ++i) {
        if (hashes[i] != hashes[i - 1]) {
            count = 1;
        } else {
            ++count;
            max = std::max(count, max);
        }
    }
    return max;
}

int main() {
    while (true) {
        std::string line{};
        std::getline(std::cin, line);
        if (line.empty()) {
            break;
        }
        std::erase_if(line, [](char c) { return c == ' '; });

        auto prefix_hashes = getPrefixHashes(line);
        auto powers = getPowers(prefix_hashes);
        for (std::size_t i = 1; i < line.length(); ++i) {
            int count = countDuplicateSubstrings(static_cast<int>(i), line,
                                                 prefix_hashes, powers);
            if (count > 1) {
                std::cout << count << "\n";
            } else {
                std::cout << "\n";
                break;
            }
        }
    }
}
