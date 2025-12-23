// For more information on writing tests, see
// https://scalameta.org/munit/docs/getting-started.html
class Part2Spec extends munit.FunSuite {
  val points: List[Point] = Point.parseAll("""
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
""")

  test("example") {
    val obtained = Part2(points).bestArea
    val expected = 24L
    assertEquals(obtained, expected)
  }

  test("valid rectangle (example 1)") {
    val a = Point.parse("11,7")
    val b = Point.parse("9,1")
    val obtained = Part2(points).isValidRectangle(a, b)
    val expected = true
    assertEquals(obtained, expected)
  }

  test("valid rectangle (example 2)") {
    val a = Point.parse("9,5")
    val b = Point.parse("2,3")
    val obtained = Part2(points).isValidRectangle(a, b)
    val expected = true
    assertEquals(obtained, expected)
  }

  test("invalid rectangle") {
    val a = Point.parse("2,3")
    val b = Point.parse("7,1")
    val obtained = Part2(points).isValidRectangle(a, b)
    val expected = false
    assertEquals(obtained, expected)
  }

  test("invalid rectangle crossing concave polygon (vertical)") {
    val points = Point.parseAll("""
7,1
11,1
11,7
9,7
9,5
8,5
8,4
7,4
7,5
2,5
2,3
7,3
""")
    val a = Point.parse("9,5")
    val b = Point.parse("2,3")
    val obtained = Part2(points).isValidRectangle(a, b)
    val expected = false
    assertEquals(obtained, expected)
  }

  test("invalid rectangle crossing concave polygon (horizontal)") {
    val points = Point.parseAll("""
7,1
11,1
11,7
9,7
9,5
2,5
2,4
10,4
10,3
2,3
2,2
7,2
""")
    val a = Point.parse("9,5")
    val b = Point.parse("2,2")
    val obtained = Part2(points).isValidRectangle(a, b)
    val expected = false
    assertEquals(obtained, expected)
  }

  test("red tile") {
    val p = Point(7, 3)
    val obtained = Part2(points).isValidTile(p)
    val expected = true
    assertEquals(obtained, expected)
  }

  test("green tile") {
    val p = Point(8, 4)
    val obtained = Part2(points).isValidTile(p)
    val expected = true
    assertEquals(obtained, expected)
  }

  test("green tile aligned with horizontal edge") {
    val p = Point(9, 3)
    val obtained = Part2(points).isValidTile(p)
    val expected = true
    assertEquals(obtained, expected)
  }

  test("not a green tile") {
    val p = Point(13, 8)
    val obtained = Part2(points).isValidTile(p)
    val expected = false
    assertEquals(obtained, expected)
  }

  test("ray crosses side") {
    val left = Point(2, 2)
    val right = Point(4, 2)
    val ray = Pair(left, right)

    val bottom = Point(3, 1)
    val top = Point(3, 3)
    val side = Pair(bottom, top)

    val obtained = Part2(points).rayCrossesSide(ray, side)
    val expected = true
    assertEquals(obtained, expected)
  }

  test("ray touches top of side") {
    val left = Point(2, 2)
    val right = Point(4, 2)
    val ray = Pair(left, right)

    val bottom = Point(3, 1)
    val top = Point(3, 2)
    val side = Pair(bottom, top)

    val obtained = Part2(points).rayCrossesSide(ray, side)
    val expected = false
    assertEquals(obtained, expected)
  }

  test("ray touches bottom of side") {
    val left = Point(2, 2)
    val right = Point(4, 2)
    val ray = Pair(left, right)

    val bottom = Point(3, 2)
    val top = Point(3, 3)
    val side = Pair(bottom, top)

    val obtained = Part2(points).rayCrossesSide(ray, side)
    val expected = true
    assertEquals(obtained, expected)
  }

  test("ray is lower than the side") {
    val left = Point(2, 2)
    val right = Point(4, 2)
    val ray = Pair(left, right)

    val bottom = Point(3, 3)
    val top = Point(3, 5)
    val side = Pair(bottom, top)

    val obtained = Part2(points).rayCrossesSide(ray, side)
    val expected = false
    assertEquals(obtained, expected)
  }

  test("ray is higher than the side") {
    val left = Point(2, 4)
    val right = Point(4, 4)
    val ray = Pair(left, right)

    val bottom = Point(3, 1)
    val top = Point(3, 3)
    val side = Pair(bottom, top)

    val obtained = Part2(points).rayCrossesSide(ray, side)
    val expected = false
    assertEquals(obtained, expected)
  }

  test("ray to the right of side") {
    val left = Point(5, 2)
    val right = Point(6, 2)
    val ray = Pair(left, right)

    val bottom = Point(3, 1)
    val top = Point(3, 4)
    val side = Pair(bottom, top)

    val obtained = Part2(points).rayCrossesSide(ray, side)
    val expected = false
    assertEquals(obtained, expected)
  }

  test("edges intersect (vertical and horizontal)") {
    val p1 = Point(9, 2)
    val p2 = Point(9, 5)
    val e1 = Pair(p1, p2)

    val p3 = Point(2, 3)
    val p4 = Point(10, 3)
    val e2 = Pair(p3, p4)

    val obtained = Part2(points).edgesIntersect(e1, e2)
    val expected = true
    assertEquals(obtained, expected)
  }
}
