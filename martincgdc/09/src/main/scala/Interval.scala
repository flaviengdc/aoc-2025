case class Interval[T] private (from: Long, to: Long, value: T):
  /** Whether the interval contains some value */
  @inline def contains(x: Long): Boolean =
    from <= x && x <= to

  /** Whether the interval is entirely before some value */
  @inline def before(x: Long): Boolean =
    to < x

  /** Whether the interval is entirely after some value */
  @inline def after(x: Long): Boolean =
    x < from

object Interval:
  def apply[T](a: Long, b: Long, value: T): Interval[T] =
    if a <= b then new Interval(a, b, value)
    else new Interval(b, a, value)
