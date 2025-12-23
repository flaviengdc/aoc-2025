case class Point(x: Long, y: Long) derives CanEqual:
  def areaTo(other: Point): Long =
    val m = (x - other.x).abs + 1
    val n = (y - other.y).abs + 1
    m * n

object Point:
  def parse(str: String): Point =
    str.split(",").map(_.trim.toLong) match
      case Array(x, y, _*) => Point(x, y)
      case _ => throw new IllegalArgumentException(s"Malformed point: $str")

  def parseAll(str: String): List[Point] =
    str.linesIterator
      .map(_.trim)
      .filter(_.nonEmpty)
      .map(Point.parse)
      .toList
