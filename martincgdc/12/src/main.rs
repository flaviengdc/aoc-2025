use std::fs;

mod matrix;
mod parser;
mod region;
mod shape;
mod solution;

fn main() {
    let filename = "example.txt";

    let contents = fs::read_to_string(filename).expect("cannot read file");
    let (shapes, regions) = parser::parse_file(&contents);

    let mut n = 0;
    for region in regions {
        let solved = solution::solve(&region, &shapes);
        if solved {
            n += 1;
        }
    }

    println!("{}", n);
}
