from typing import Self


class GraphNode:
    def __init__(self) -> None:
        self.children: list[Self] = []
        self.count: int | None = None

    def add_children(self, *children: Self):
        self.children.extend(children)

    def count_possible_journeys(self) -> int:
        if self.count:
            return self.count

        if len(self.children) == 0:
            self.count = 1
            return self.count

        result = sum([child.count_possible_journeys() for child in self.children])

        self.count = result
        return result
