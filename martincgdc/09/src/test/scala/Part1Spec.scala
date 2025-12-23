// For more information on writing tests, see
// https://scalameta.org/munit/docs/getting-started.html
class Part1Spec extends munit.FunSuite {
  test("example") {
    val points = Point.parseAll("""
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
""")
    val obtained = Part1(points).bestArea
    val expected = 50L
    assertEquals(obtained, expected)
  }
}
