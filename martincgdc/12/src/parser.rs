use crate::region::Region;
use crate::shape::Shape;
use pest::Parser;
use pest_derive::Parser;

#[derive(Parser)]
#[grammar = "grammar.pest"]
struct InputParser;

pub fn parse_file(contents: &str) -> (Vec<Shape>, Vec<Region>) {
    let file = InputParser::parse(Rule::file, &contents)
        .expect("unsuccessful parse")
        .next()
        .unwrap();

    let mut shapes: Vec<Shape> = vec![];
    let mut regions: Vec<Region> = vec![];

    for component in file.into_inner() {
        match component.as_rule() {
            Rule::shapes => {
                for parsed_shape in component.into_inner() {
                    if let Rule::newline = parsed_shape.as_rule() {
                        continue;
                    }

                    let mut shape = Shape::default();

                    for shape_component in parsed_shape.into_inner() {
                        match shape_component.as_rule() {
                            Rule::shape_line => {
                                let line: Vec<bool> =
                                    shape_component.as_str().chars().map(|x| x == '#').collect();
                                shape.parts.push(line);
                            }
                            Rule::index => {}
                            Rule::newline => {}
                            _ => unreachable!(),
                        }
                    }
                    shapes.push(shape);
                }
            }

            Rule::regions => {
                for parsed_region in component.into_inner() {
                    if let Rule::newline = parsed_region.as_rule() {
                        continue;
                    }

                    let mut region = Region::default();

                    for region_component in parsed_region.into_inner() {
                        match region_component.as_rule() {
                            Rule::region_size => {
                                for size_component in region_component.into_inner() {
                                    match size_component.as_rule() {
                                        Rule::width => {
                                            region.width = size_component.as_str().parse().unwrap();
                                        }
                                        Rule::height => {
                                            region.height =
                                                size_component.as_str().parse().unwrap();
                                        }
                                        _ => unreachable!(),
                                    }
                                }
                            }
                            Rule::region_present_quantity => {
                                let mut quantities: Vec<u64> = vec![];
                                for quantity in region_component.into_inner() {
                                    match quantity.as_rule() {
                                        Rule::ws => {}
                                        Rule::integer => {
                                            quantities.push(quantity.as_str().parse().unwrap());
                                        }
                                        _ => unreachable!(),
                                    }
                                }
                                region.quantities = quantities;
                            }
                            Rule::ws => {}
                            _ => unreachable!(),
                        }
                    }

                    regions.push(region);
                }
            }

            Rule::newline => {}
            Rule::EOI => {}
            _ => unreachable!(),
        }
    }

    (shapes, regions)
}
