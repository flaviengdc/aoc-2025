use std::env;
use std::fs;

fn rotate_turns(current_dial_value: &mut i32, rotate_value: i32, turns: i32, password: &mut i32) {
    for _ in 0..turns {
        *current_dial_value += rotate_value;
        if *current_dial_value % 100 == 0 {
            *password += 1;
        };
    };
}

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
            Some('L') => rotate_turns(&mut current_dial_value, -1, turns, &mut password),
            Some('R') => rotate_turns(&mut current_dial_value, 1, turns, &mut password),
            _ => println!("failed to handle line with value: {}", line),
        };
    }

    println!("{}", password);
}