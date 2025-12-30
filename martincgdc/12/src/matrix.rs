#[derive(Clone, Debug, Default, Hash, PartialEq, Eq)]
pub struct Matrix {
    pub cells: Vec<Vec<bool>>,
}

impl Matrix {
    pub fn new(height: usize, width: usize) -> Self {
        let cells = vec![vec![false; width]; height];
        Matrix { cells }
    }

    #[cfg(test)]
    pub fn from_string(s: &str) -> Self {
        let cells = s
            .lines()
            .filter(|line| !line.trim().is_empty())
            .map(|line| line.chars().map(|c| c == '#').collect::<Vec<bool>>())
            .collect();

        Matrix { cells }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_matrix_from_string() {
        let matrix = Matrix::from_string(
            r#"
...#.
..#..
.....
"#,
        );

        let expected = Matrix {
            cells: vec![
                vec![false, false, false, true, false],
                vec![false, false, true, false, false],
                vec![false, false, false, false, false],
            ],
        };

        assert_eq!(matrix, expected);
    }
}
