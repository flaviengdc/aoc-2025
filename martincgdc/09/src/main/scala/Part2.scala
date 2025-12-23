import scala.util.chaining._

class Part2(points: List[Point]):
  val redTiles: Set[Point] = Set(points*)
  val pairs: List[Pair] = Pair.fromPoints(points)

  val verticalSides: IntervalTree[Pair] = pairs
    .filter(side => side.a.x == side.b.x)
    .map(side => Interval(side.a.y, side.b.y, side))
    .pipe(IntervalTree.fromIntervals)

  val horizontalSides: IntervalTree[Pair] = pairs
    .filter(side => side.a.y == side.b.y)
    .map(side => Interval(side.a.x, side.b.x, side))
    .pipe(IntervalTree.fromIntervals)

  def isValidTile(p: Point): Boolean =
    if redTiles.contains(p) then true
    else
      // Ray casting algorithm
      val a = Point(0, p.y)
      val ray = Pair(a, p)

      val crossings = verticalSides
        .containing(p.y)
        .map(_.value)
        .count(side => rayCrossesSide(ray, side))

      crossings % 2 != 0

  def rayCrossesSide(ray: Pair, side: Pair): Boolean =
    if (
      ray.a.x >= side.a.x && ray.b.x >= side.a.x && ray.a.x >= side.b.x && ray.b.x >= side.b.x
    ) return false
    if (
      ray.a.x < side.a.x && ray.b.x < side.a.x && ray.a.x < side.b.x && ray.b.x < side.b.x
    ) return false
    if (
      ray.a.y >= side.a.y && ray.b.y >= side.a.y && ray.a.y >= side.b.y && ray.b.y >= side.b.y
    ) return false
    if (
      ray.a.y < side.a.y && ray.b.y < side.a.y && ray.a.y < side.b.y && ray.b.y < side.b.y
    ) return false

    true

  def edgesIntersect(e1: Pair, e2: Pair): Boolean =
    if math.max(e1.a.x, e1.b.x) <= math.min(e2.a.x, e2.b.x) then return false
    if math.min(e1.a.x, e1.b.x) >= math.max(e2.a.x, e2.b.x) then return false
    if math.max(e1.a.y, e1.b.y) <= math.min(e2.a.y, e2.b.y) then return false
    if math.min(e1.a.y, e1.b.y) >= math.max(e2.a.y, e2.b.y) then return false
    true

  def isValidRectangle(a: Point, c: Point): Boolean =
    val b = Point(a.x, c.y)
    val d = Point(c.x, a.y)

    // First, make sure every corner is a red or green tile
    // We already know a and c are red tiles
    val areCornersValid = List(b, d).forall(isValidTile)
    if !areCornersValid then return false

    val verticalIntersections =
      List(Pair(a, b), Pair(c, d)).exists(rectEdge =>
        horizontalSides
          .containing(rectEdge.a.x)
          .map(_.value)
          .exists(edgesIntersect(rectEdge, _))
      )
    if verticalIntersections then return false

    val horizontalIntersections =
      List(Pair(b, c), Pair(d, a)).exists(rectEdge =>
        verticalSides
          .containing(rectEdge.a.y)
          .map(_.value)
          .exists(edgesIntersect(rectEdge, _))
      )
    if horizontalIntersections then return false

    true

  def bestArea: Long =
    Pair
      .fromPoints(points)
      .iterator
      .filter(pair => isValidRectangle(pair.a, pair.b))
      .map(_.area)
      .max
