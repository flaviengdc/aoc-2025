use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let file_path = &args[1];
    let mut password: i32 = 0;
    let mut current_dial_value: i32 = 50;
    let file_as_string: String = fs::read_to_string(file_path)
        .unwrap();

    let lines: Vec<&str> = file_as_string
        .split("\n")
        .collect();

    for line in lines.iter() {
        let turns: i32 = line[1..].parse::<i32>().unwrap();
        match line.chars().nth(0) {
            Some('L') => current_dial_value = current_dial_value - turns,
            Some('R') => current_dial_value = current_dial_value + turns,
            _ => println!("failed to handle line with value: {}", line),
        };
        if current_dial_value % 100 == 0 {
            password += 1;
        };
    }

    println!("password is {}", password);
}