#!/usr/bin/env python3

from manifold import Manifold


def get_data() -> str:
    filename = "example.txt"
    with open(filename) as f:
        return f.read()


def main() -> None:
    manifold = Manifold(get_data())
    print(manifold.get_split_count())

    graph = manifold.as_graph()
    print(graph.count_possible_journeys())


if __name__ == "__main__":
    main()
