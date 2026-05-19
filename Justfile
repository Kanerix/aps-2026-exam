# aps – project recipes

[private]
default:
    @just --list

# Exchange rates problem
exchange-rates:
    @rustc -C opt-level=3 -C target-cpu=native --crate-type bin --edition 2021 exchange_rates.rs -o exchange_rates
    @cat data/exchange_rates.in | ./exchange_rates

# Byzzwords problem
buzzwords:
    @# g++-14 -g -O2 -o buzzwords -std=gnu++23 -static -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive buzzwords.cc
    @g++ -g -O2 -o buzzwords -std=gnu++23 buzzwords.cc
    @./buzzwords

# Cookie selection problem
cookie-selection:
    @# pypy3 'cookie_selection.py'
    @python3 'cookie_selection.py'

# Our assignment problem
assignment:
    @rustc -C opt-level=3 -C target-cpu=native --crate-type bin --edition 2021 assignment/submissions/accepted/main.rs -o homerenovation
    cat assignment/data/sample/1.in | ./homerenovation
