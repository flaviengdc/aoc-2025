/** A pair of points */
case class Pair(a: Point, b: Point) derives CanEqual:
  def area: Long = a.areaTo(b)

object Pair:
  def fromPoints(points: List[Point]): List[Pair] =
    for
      (a, i) <- points.zipWithIndex
      b <- points.drop(i + 1)
    yield Pair(a, b)
