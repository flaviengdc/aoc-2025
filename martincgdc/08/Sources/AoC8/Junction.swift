struct Junction: Hashable {
  public var a, b: Vec3

  func hash(into hasher: inout Hasher) {
    hasher.combine(a)
    hasher.combine(b)
  }
}
