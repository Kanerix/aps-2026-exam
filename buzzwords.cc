#include <iostream>
#include <string>

int main() {
    while (true) {
        std::string line{};
        std::getline(std::cin, line);
        if (line.empty()) {
            break;
        }

        std::size_t max_len = line.length() / 2 + 1;
        for (std::size_t i = 0; i < max_len; ++i) {
        }
    }
}
