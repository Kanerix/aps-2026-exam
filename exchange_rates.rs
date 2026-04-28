use std::io::{self, Read};

#[inline(always)]
fn read_input() -> String {
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer).unwrap();
    buffer
}

#[inline(always)]
fn to_int(s: &str) -> f32 {
    s.parse().unwrap()
}

fn main() {
    let input = read_input();
    let mut lines = input.lines();

    while let Some(line) = lines.next() {
        let num_cases = to_int(line) as usize;
        dbg!(num_cases);

        for i in 0..num_cases {
            let case = to_int(lines.next().unwrap());
            dbg!(case);
        }
    }
}
