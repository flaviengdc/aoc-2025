use std::collections::HashSet;

#[derive(Clone, Debug, Default, Hash, PartialEq, Eq)]
pub struct Shape {
    pub parts: Vec<Vec<bool>>,
}

impl Shape {
    pub fn count(&self) -> u64 {
        self.parts
            .iter()
            .flatten()
            .filter(|&&b| b)
            .count()
            .try_into()
            .unwrap()
    }

    /// Dihedral group D4
    pub fn variations(&self) -> HashSet<Self> {
        let variations: Vec<Self> = vec![self.rotations(), self.flipped().rotations()]
            .into_iter()
            .flatten()
            .collect();
        HashSet::from_iter(variations)
    }

    fn rotations(&self) -> Vec<Self> {
        debug_assert!(
            self.parts.iter().all(|r| r.len() == self.parts.len()),
            "rotation only works for square matrices"
        );

        let rotated_once = self.rotated();
        let rotated_twice = rotated_once.rotated();
        let rotated_thrice = rotated_twice.rotated();

        vec![self.clone(), rotated_once, rotated_twice, rotated_thrice]
    }

    fn rotated(&self) -> Self {
        let mut shape = self.clone();
        for (i, self_line) in self.parts.iter().enumerate() {
            for (j, x) in self_line.iter().enumerate() {
                let n = self_line.len();
                shape.parts[j][n - 1 - i] = *x;
            }
        }
        shape
    }

    fn flipped(&self) -> Self {
        let mut shape = self.clone();
        for (i, self_line) in self.parts.iter().enumerate() {
            for (j, x) in self_line.iter().enumerate() {
                let n = self_line.len();
                shape.parts[n - 1 - i][j] = *x;
            }
        }
        shape
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_count() {
        let shape = Shape {
            parts: vec![
                vec![true, true, false],
                vec![true, true, true],
                vec![true, false, true],
            ],
        };

        assert_eq!(shape.count(), 7);
    }

    #[test]
    fn test_variations() {
        let shape = Shape {
            parts: vec![
                vec![true, true, false],
                vec![true, true, true],
                vec![true, false, true],
            ],
        };

        let expected = vec![
            Shape {
                parts: vec![
                    vec![true, true, false],
                    vec![true, true, true],
                    vec![true, false, true],
                ],
            },
            Shape {
                parts: vec![
                    vec![true, false, true],
                    vec![true, true, true],
                    vec![false, true, true],
                ],
            },
            Shape {
                parts: vec![
                    vec![false, true, true],
                    vec![true, true, false],
                    vec![true, true, true],
                ],
            },
            Shape {
                parts: vec![
                    vec![true, true, true],
                    vec![false, true, true],
                    vec![true, true, false],
                ],
            },
            Shape {
                parts: vec![
                    vec![true, false, true],
                    vec![true, true, true],
                    vec![true, true, false],
                ],
            },
            Shape {
                parts: vec![
                    vec![false, true, true],
                    vec![true, true, true],
                    vec![true, false, true],
                ],
            },
            Shape {
                parts: vec![
                    vec![true, true, false],
                    vec![false, true, true],
                    vec![true, true, true],
                ],
            },
            Shape {
                parts: vec![
                    vec![true, true, true],
                    vec![true, true, false],
                    vec![false, true, true],
                ],
            },
        ];

        assert_eq!(shape.variations(), HashSet::from_iter(expected));
    }

    #[test]
    fn test_symmetric_variations() {
        let shape = Shape {
            parts: vec![
                vec![true, false, true],
                vec![true, true, true],
                vec![true, false, true],
            ],
        };

        let expected = vec![
            Shape {
                parts: vec![
                    vec![true, false, true],
                    vec![true, true, true],
                    vec![true, false, true],
                ],
            },
            Shape {
                parts: vec![
                    vec![true, true, true],
                    vec![false, true, false],
                    vec![true, true, true],
                ],
            },
        ];

        assert_eq!(shape.variations(), HashSet::from_iter(expected));
    }
}
