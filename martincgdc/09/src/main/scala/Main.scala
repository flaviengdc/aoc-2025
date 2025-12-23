@main def main(): Unit =
  val filename = "example.txt"
  val contents = io.Source.fromFile(filename, "UTF-8").mkString

  val points = Point.parseAll(contents)

  val bestArea1 = Part1(points).bestArea
  println(s"Part 1: $bestArea1")

  val bestArea2 = Part2(points).bestArea
  println(s"Part 2: $bestArea2")
