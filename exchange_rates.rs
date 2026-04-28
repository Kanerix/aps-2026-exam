use std::io::{self, Read};

#[inline(always)]
fn read_input() -> io::Result<String> {
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer)?;
    Ok(buffer)
}

fn main() {
    let input = read_input().unwrap();
    println!("{}", input);
}
