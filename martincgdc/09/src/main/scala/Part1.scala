class Part1(points: List[Point]):
  def bestArea: Long =
    Pair.fromPoints(points).iterator.map(_.area).max
