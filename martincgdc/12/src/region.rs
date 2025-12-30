use crate::{matrix::Matrix, shape::Shape};

#[derive(Clone, Debug, Default, Hash, PartialEq, Eq)]
pub struct Region {
    pub height: usize,
    pub width: usize,
    pub quantities: Vec<u64>,
}

impl Region {
    pub fn area(&self) -> u64 {
        (self.width as u64) * (self.height as u64)
    }

    pub fn to_empty_matrix(&self) -> Matrix {
        Matrix::new(self.height, self.width)
    }

    pub fn total_quantities_count(&self, shapes: &[Shape]) -> u64 {
        debug_assert_eq!(self.quantities.len(), shapes.len());

        let mut sum = 0;
        for (i, quantity) in self.quantities.iter().enumerate() {
            let shape = &shapes[i];
            sum += quantity * shape.count();
        }
        sum
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_area() {
        let region = Region {
            height: 12,
            width: 23,
            ..Default::default()
        };

        assert_eq!(region.area(), 276);
    }

    #[test]
    fn test_total_quantities_count() {
        let region = Region {
            quantities: vec![0, 0, 3, 1, 0, 2],
            ..Default::default()
        };

        let shapes = vec![
            Shape {
                parts: vec![
                    vec![true, true, false],
                    vec![true, false, true],
                    vec![false, false, true],
                ],
            },
            Shape {
                parts: vec![
                    vec![true, false, true],
                    vec![false, false, true],
                    vec![true, true, false],
                ],
            },
            Shape {
                parts: vec![
                    vec![false, false, true],
                    vec![true, true, false],
                    vec![true, false, true],
                ],
            },
            Shape {
                parts: vec![
                    vec![true, false, true],
                    vec![true, true, false],
                    vec![true, false, true],
                ],
            },
            Shape {
                parts: vec![
                    vec![true, false, true],
                    vec![true, false, false],
                    vec![true, false, true],
                ],
            },
            Shape {
                parts: vec![
                    vec![true, false, true],
                    vec![false, false, false],
                    vec![true, false, true],
                ],
            },
        ];

        assert_eq!(region.total_quantities_count(&shapes), 29);
    }
}
