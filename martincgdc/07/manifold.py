from enum import Enum
from itertools import pairwise

from graph import GraphNode

type NodeList = list[GraphNode | None]


class Item(Enum):
    EMPTY = "."
    START = "S"
    SPLITTER = "^"
    BEAM = "|"


type Pair = tuple[Item, Item]


class Manifold:
    def __init__(self, data: str) -> None:
        self.lines = [self._parse_line(line) for line in data.split("\n") if line != ""]

    def _parse_line(self, line: str) -> list[Item]:
        return [Item(c) for c in line]

    def get_next_pair(self, prev_items: Pair, cur_items: Pair) -> Pair:
        (a, b) = prev_items
        (c, d) = cur_items

        match ((a, b), (c, d)):
            case (_, Item.START), (x, Item.EMPTY):
                return x, Item.BEAM
            case (_, Item.BEAM), (x, Item.EMPTY):
                return x, Item.BEAM

            case (Item.START, _), (Item.EMPTY, y):
                return Item.BEAM, y
            case (Item.BEAM, _), (Item.EMPTY, y):
                return Item.BEAM, y

            case (Item.START, _), (Item.SPLITTER, _):
                return Item.SPLITTER, Item.BEAM
            case (Item.BEAM, _), (Item.SPLITTER, _):
                return Item.SPLITTER, Item.BEAM

            case (_, Item.START), (_, Item.SPLITTER):
                return Item.BEAM, Item.SPLITTER
            case (_, Item.BEAM), (_, Item.SPLITTER):
                return Item.BEAM, Item.SPLITTER

            case (_, _), (x, y):
                return (x, y)

    def get_next_line(self, prev_line: list[Item], cur_line: list[Item]) -> list[Item]:
        next_line_pairs: list[Pair] = []

        for (a, c), (b, d) in pairwise(zip(prev_line, cur_line, strict=True)):
            next_pair = self.get_next_pair((a, b), (c, d))
            next_line_pairs.append(next_pair)

        def merge(a: Item, b: Item):
            if a == Item.EMPTY:
                return b
            return a

        pairs = zip(
            [*[a for (a, _) in next_line_pairs], Item.EMPTY],
            [Item.EMPTY, *[b for (_, b) in next_line_pairs]],
            strict=True,
        )

        return [merge(a, b) for (a, b) in pairs]

    def propagate_beam(self) -> None:
        [prev_line, *other_lines] = self.lines
        new_lines = [prev_line]

        for line in other_lines:
            new_line = self.get_next_line(prev_line, line)
            new_lines.append(new_line)

            prev_line = new_line

        self.lines = new_lines

    def get_split_count(self) -> int:
        self.propagate_beam()
        result = 0

        for prev_line, line in pairwise(self.lines):
            for prev_item, cur_item in zip(prev_line, line, strict=True):
                match prev_item, cur_item:
                    case Item.BEAM, Item.SPLITTER:
                        result += 1
                    case _, _:
                        pass

        return result

    def as_graph(self) -> GraphNode:
        self.propagate_beam()

        root = GraphNode()

        all_nodes: list[NodeList] = []

        for i, (prev_line, line) in enumerate(pairwise(self.lines)):
            nodes: NodeList = [None] * len(line)

            for j, (prev_item, cur_item) in enumerate(
                zip(prev_line, line, strict=True)
            ):
                match prev_item, cur_item:
                    case Item.START, Item.BEAM:
                        g = GraphNode()
                        nodes[j] = g
                        root = g

                    case Item.BEAM, Item.BEAM:
                        cur_node = nodes[j]
                        parent_node = all_nodes[i - 1][j]
                        if not (parent_node):
                            continue
                        if cur_node:
                            parent_node.add_children(cur_node)
                        else:
                            nodes[j] = parent_node

                    case Item.BEAM, Item.SPLITTER:
                        g = GraphNode()
                        old_g = nodes[j - 1]
                        if old_g:
                            old_g.add_children(g)
                        nodes[j - 1] = g

                        h = GraphNode()
                        old_h = nodes[j + 1]
                        if old_h:
                            old_h.add_children(h)
                        nodes[j + 1] = h

                        parent = all_nodes[i - 1][j]
                        if parent:
                            parent.add_children(g, h)

                    case _, _:
                        pass

            all_nodes.append(nodes)

        return root
