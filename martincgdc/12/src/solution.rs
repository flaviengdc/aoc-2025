use std::collections::HashMap;

use crate::{matrix::Matrix, region::Region, shape::Shape};

pub fn solve(region: &Region, shapes: &[Shape]) -> bool {
    if region.area() < region.total_quantities_count(shapes) {
        return false;
    }

    solve_with_matrix(
        region,
        shapes,
        &region.to_empty_matrix(),
        &mut HashMap::new(),
    )
}

type MemoKey = (Shape, Matrix);

pub fn solve_with_matrix(
    region: &Region,
    shapes: &[Shape],
    matrix: &Matrix,
    memo: &mut HashMap<MemoKey, bool>,
) -> bool {
    let maybe_shape_index = region.quantities.iter().position(|quantity| *quantity != 0);

    if maybe_shape_index.is_none() {
        // All quantities are 0
        return true;
    }

    let i = maybe_shape_index.unwrap();
    let shape = &shapes[i];

    let memo_key = (shape.clone(), matrix.clone());

    if let Some(result) = memo.get(&memo_key) {
        return *result;
    }

    for variation in shape.variations() {
        let max_height = region.height - variation.parts[0].len() + 1;
        let max_width = region.width - variation.parts.len() + 1;

        for x in 0..max_height {
            for y in 0..max_width {
                let at = (x, y);

                if let Some(new_matrix) = add_shape(at, &variation, &matrix) {
                    let mut new_region = region.clone();
                    new_region.quantities[i] -= 1;

                    let result = solve_with_matrix(&new_region, shapes, &new_matrix, memo);
                    if result {
                        memo.insert(memo_key, true);
                        return true;
                    }
                }
            }
        }
    }

    // Could not find a way to place the first shape in the current matrix
    memo.insert(memo_key, false);
    return false;
}

fn add_shape(at: (usize, usize), shape: &Shape, matrix: &Matrix) -> Option<Matrix> {
    if !can_add_shape(at, shape, matrix) {
        return None;
    }

    let mut new_matrix = matrix.clone();
    for (i, line) in shape.parts.iter().enumerate() {
        for (j, cell) in line.iter().enumerate() {
            if *cell {
                new_matrix.cells[at.0 + i][at.1 + j] = true;
            }
        }
    }

    Some(new_matrix)
}

fn can_add_shape(at: (usize, usize), shape: &Shape, matrix: &Matrix) -> bool {
    for (i, line) in shape.parts.iter().enumerate() {
        for (j, cell) in line.iter().enumerate() {
            if !*cell {
                continue;
            }

            let maybe_line = matrix.cells.get(at.0 + i);
            let maybe_existing_cell = maybe_line.and_then(|line| line.get(at.1 + j));

            if let Some(existing_cell) = maybe_existing_cell {
                if *existing_cell {
                    return false;
                }
            } else {
                return false;
            }
        }
    }

    true
}

#[cfg(test)]
mod tests {
    use crate::parser;

    use super::*;

    #[test]
    fn test_can_add_shape_empty() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
##.
##.

4x4: 1
"#,
        );

        let at = (1, 1);
        let shape = &shapes[0];
        let matrix = regions[0].to_empty_matrix();

        assert_eq!(can_add_shape(at, &shape, &matrix), true);
    }

    #[test]
    fn test_can_add_shape_one_shape_remaining() {
        let (shapes, _regions) = parser::parse_file(
            r#"
0:
#..
#..
#..

1:
.#.
.#.
.#.

4x4: 0 1
"#,
        );

        let at = (0, 3);
        let shape = &shapes[0];
        let matrix = Matrix::from_string(
            r#"
###.
###.
###.
....
"#,
        );

        assert_eq!(can_add_shape(at, shape, &matrix), true);
    }

    #[test]
    fn test_can_add_shape_too_low() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
##.
##.

4x4: 1
"#,
        );

        let at = (2, 2);
        let shape = &shapes[0];
        let matrix = regions[0].to_empty_matrix();

        assert_eq!(can_add_shape(at, &shape, &matrix), false);
    }

    #[test]
    fn test_can_add_shape_too_big() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
##.
##.

2x2: 1
"#,
        );

        let at = (0, 0);
        let shape = &shapes[0];
        let matrix = regions[0].to_empty_matrix();

        assert_eq!(can_add_shape(at, &shape, &matrix), false);
    }

    #[test]
    fn test_can_add_shape_too_full() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
##.
##.

1:
###
##.
.##

4x4: 1 1
"#,
        );

        let at = (1, 1);
        let shape = &shapes[0];

        let empty_matrix = regions[0].to_empty_matrix();
        let matrix = add_shape((0, 0), &shapes[1], &empty_matrix).unwrap();

        assert_eq!(can_add_shape(at, &shape, &matrix), false);
    }

    #[test]
    fn test_solve_one_shape() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
##.
##.

4x4: 1
"#,
        );

        let region = &regions[0];
        assert_eq!(solve(region, &shapes), true);
    }

    #[test]
    fn test_solve_one_shape_twice() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
##.
##.

8x8: 2
"#,
        );

        let region = &regions[0];
        assert_eq!(solve(region, &shapes), true);
    }

    #[test]
    fn test_solve_two_shapes() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
#..
#..
#..

1:
.#.
.#.
.#.

4x4: 1 1
"#,
        );

        let region = &regions[0];
        assert_eq!(solve(region, &shapes), true);
    }

    #[test]
    fn test_solve_two_shapes_twice() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
#..
#..
#..

1:
.#.
.#.
.#.

4x4: 2 2
"#,
        );

        let region = &regions[0];
        assert_eq!(solve(region, &shapes), true);
    }

    #[test]
    fn test_solve_with_empty_matrix() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

12x5: 1 0 0 0 0 0
"#,
        );

        let region = &regions[0];
        let matrix = Matrix::from_string(
            r#"
............
............
............
............
............
"#,
        );

        assert_eq!(
            solve_with_matrix(region, &shapes, &matrix, &mut HashMap::new()),
            true
        );
    }

    #[test]
    fn test_solve_with_matrix_one_shape_remaining() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
#..
#..
#..

1:
#..
#..
#..

4x4: 0 1
"#,
        );

        let region = &regions[0];
        let matrix = Matrix::from_string(
            r#"
###.
###.
###.
....
"#,
        );

        assert_eq!(
            solve_with_matrix(region, &shapes, &matrix, &mut HashMap::new()),
            true
        );
    }

    #[test]
    fn test_solve_with_matrix_two_shapes_remaining() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

12x5: 0 0 0 0 0 2
"#,
        );

        let region = &regions[0];
        let matrix = Matrix::from_string(
            r#"
###..##.....
#.#.###.....
#######.....
.#.####.....
.######.....
"#,
        );

        assert_eq!(
            solve_with_matrix(region, &shapes, &matrix, &mut HashMap::new()),
            true
        );
    }

    #[test]
    fn test_solve_example() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

12x5: 1 0 1 0 2 2
"#,
        );

        let region = &regions[0];
        assert_eq!(solve(region, &shapes), true);
    }

    #[test]
    fn test_solve_impossible_example() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

12x5: 1 0 1 0 3 2
"#,
        );

        let region = &regions[0];
        assert_eq!(solve(region, &shapes), false);
    }

    #[test]
    fn test_solve_too_small() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
###
###

4x4: 2
"#,
        );

        let region = &regions[0];
        assert_eq!(solve(region, &shapes), false);
    }

    #[test]
    fn test_solve_not_possible() {
        let (shapes, regions) = parser::parse_file(
            r#"
0:
###
###
###

5x5: 2
"#,
        );

        let region = &regions[0];
        assert_eq!(solve(region, &shapes), false);
    }
}
