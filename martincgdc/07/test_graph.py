from graph import GraphNode


def test_count_possible_journeys():
    n1 = GraphNode()
    n2 = GraphNode()
    n3 = GraphNode()
    n4 = GraphNode()
    n5 = GraphNode()
    n6 = GraphNode()
    n7 = GraphNode()
    n8 = GraphNode()
    n9 = GraphNode()

    n1.add_children(n2, n3)
    n3.add_children(n4, n5)
    n5.add_children(n6, n7)
    n4.add_children(n6)
    n6.add_children(n8, n9)

    expected = 6
    assert n1.count_possible_journeys() == expected
