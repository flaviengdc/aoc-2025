struct JunctionMap<V> where V: Comparable {
  private var map: [Junction: V] = [:]

  init() {}

  public subscript(j: Junction) -> V? {
    get {
      let alternate = Junction(a: j.b, b: j.a)
      return map[j] ?? map[alternate]
    }
    set(value) {
      map[j] = value
    }
  }

  /// Get the junctions with the smallest distances first
  public func closestNeighbors() -> [Junction] {
    return map.sorted(by: { $0.value < $1.value }).map { $0.key }
  }
}
