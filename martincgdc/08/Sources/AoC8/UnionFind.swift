struct UnionFind {
  private var parents: [Vec3: Vec3] = [:]
  private var count: [Vec3: Int] = [:]

  init(_ points: [Vec3]) {
    for point in points {
      parents[point] = point
      count[point] = 1
    }
  }

  /// Find the parent
  func find(_ v: Vec3) -> Vec3 {
    let parent = parents[v]!
    if parent == v {
      return v
    }
    return find(parent)
  }

  /// Join two points
  /// - Returns: the count of the newly formed set of points
  mutating func join(_ a: Vec3, _ b: Vec3) -> Int {
    let parentA = find(a)
    let parentB = find(b)

    // a & b are already joined: nothing happens.
    if parentA == parentB {
      return count[parentA]!
    }

    parents[parentB] = parentA
    count[parentA]! += count[parentB]!
    return count[parentA]!
  }

  /// Get largest counts first
  func largestCounts() -> [Int] {
    return
      count
      // Filter to only keep the roots
      .filter { find($0.key) == $0.key }
      .map { $0.value }.sorted(by: >)
  }
}
