struct Solution {
  static func solvePart1(_ points: [Vec3]) -> Int {
    let distances = listAllDistances(points)
    var junctions = UnionFind(points)

    let k = 10  // 1000
    for junction in distances.closestNeighbors()[0..<k] {
      _ = junctions.join(junction.a, junction.b)
    }

    let n = 3
    let counts = junctions.largestCounts()[0..<n]
    return counts.reduce(1, *)
  }

  static func solvePart2(_ points: [Vec3]) -> Int {
    let distances = listAllDistances(points)
    var junctions = UnionFind(points)

    for junction in distances.closestNeighbors() {
      if junctions.join(junction.a, junction.b) >= points.count {
        return junction.a.x * junction.b.x
      }
    }

    fatalError("Joining all points should always result in a single graph")
  }

  static func listAllDistances(_ points: [Vec3]) -> JunctionMap<Double> {
    var distances: JunctionMap<Double> = JunctionMap()

    for a in points {
      for b in points {
        if a == b { continue }

        let j = Junction(a: a, b: b)
        if distances[j] != nil { continue }

        distances[j] = a.distanceTo(b)
      }
    }

    return distances
  }
}
