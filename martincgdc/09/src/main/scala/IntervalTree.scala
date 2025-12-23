enum IntervalTree[T]:
  case Node(
      center: Long,
      overlap: List[Interval[T]],
      left: IntervalTree[T],
      right: IntervalTree[T]
  )
  case Leaf(overlap: List[Interval[T]])

  def containing(value: Long): List[Interval[T]] = this match
    case Leaf(overlap) =>
      overlap.filter(_.contains(value))

    case Node(center, overlap, left, right) =>
      val intervals = overlap.filter(_.contains(value))

      if value < center then intervals ++ left.containing(value)
      else if value > center then intervals ++ right.containing(value)
      else intervals

object IntervalTree:
  def fromIntervals[T](intervals: List[Interval[T]]): IntervalTree[T] =
    if intervals.isEmpty then return Leaf(Nil)

    val midpoints =
      intervals.map(interval => (interval.from + interval.to) / 2).sorted
    val center = midpoints(midpoints.length / 2)

    val overlap = intervals.filter(_.contains(center))
    val left = intervals.filter(_.before(center))
    val right = intervals.filter(_.after(center))

    if overlap.length == intervals.length
    then Leaf(overlap)
    else Node(center, overlap, fromIntervals(left), fromIntervals(right))
