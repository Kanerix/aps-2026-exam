//! # Exchange Rates
//!
//! This module provides the solution to the exchange rates problem from Kattis.
//! Used for Algorithmic Problem Solving Exam 2026 – Dynamic Programming.
//!
//! https://open.kattis.com/problems/exchangerates

use std::io::{self, Read, Write};

const COMMISSION: f64 = 0.97;

/// Reads input from stdin
///
/// # Examples
///
/// ```
/// let input = read_input();
/// ```
#[inline(always)]
fn read_input() -> String {
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer).unwrap();
    buffer
}

/// Writes output to stdout
///
/// # Examples
///
/// ```
/// write_output("Hello, World!");
/// ```
#[inline(always)]
fn write_output(output: &str) {
    io::stdout().write_all(output.as_bytes()).unwrap();
}

/// Converts a string to a float
///
/// # Examples
///
/// ```
/// assert_eq!(to_float("1.23"), 1.23);
/// ```
#[inline(always)]
fn to_float(s: &str) -> f64 {
    s.parse().unwrap()
}

/// Rounds a value to the nearest cent (2 decimal places)
///
/// # Examples
///
/// ```
/// assert_eq!(floor_cents(1.2345), 1.23);
/// assert_eq!(floor_cents(1.2355), 1.24);
/// ```
#[inline(always)]
fn floor_cents(amount: f64) -> f64 {
    (amount * 100.0).floor() / 100.0
}

fn main() {
    let input = read_input();
    let mut lines = input.lines();

    let mut output = String::new();

    while let Some(line) = lines.next() {
        let num_cases = to_float(line) as usize;

        if num_cases == 0 {
            break;
        }

        let mut cad: f64 = 1000.0;
        let mut usd: f64 = 0.0;

        for _ in 0..num_cases {
            let rate = to_float(lines.next().unwrap());

            let new_usd = f64::max(usd, floor_cents(cad / rate * COMMISSION));
            let new_cad = f64::max(cad, floor_cents(usd * rate * COMMISSION));

            usd = new_usd;
            cad = new_cad;
        }

        output.push_str(&format!("{:.2}\n", cad));
    }

    write_output(&output);
}
