fn main() {
    let n: usize = std::env::args().nth(1).unwrap().parse().unwrap();
    let mut s = String::new();
    for i in 0..n {
        s = s + &i.to_string() + ",";
    }
    println!("{}", s.len());
}
