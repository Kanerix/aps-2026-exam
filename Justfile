# aps – project recipes

[private]
default:
    @just --list

# Exchange rates problem
exchange-rates:
    @rustc -C opt-level=3 -C target-cpu=native --crate-type bin --edition 2021 exchange_rates.rs -o exchange_rates
    @./exchange_rates

# Byzzwords problem
buzzwords:
    @# pypy3 'buzzwords.py'
    @python3 'buzzwords.py'

# Cookie selection problem
cookie-selection:
    @# g++-14 -g -O2 -o cookie_selection -std=gnu++23 -static -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive cookie_selection.cpp
    @g++ -g -O2 -o cookie_selection -std=gnu++23 cookie_selection.cpp
    @./cookie_selection
