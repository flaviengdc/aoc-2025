import Foundation

struct Vec3: Hashable {
  var x, y, z: Int

  init(fromString str: String) {
    let ns = str.split(separator: ",")[0...2].map { str in Int(str) }
    x = ns[0]!
    y = ns[1]!
    z = ns[2]!
  }

  /// - Returns: The L2 norm of the difference between both vectors
  func distanceTo(_ other: Vec3) -> Double {
    let squared = { (n: Int) -> Double in pow(Double(n), 2) }

    return (squared(self.x - other.x) + squared(self.y - other.y) + squared(self.z - other.z))
      .squareRoot()
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
    hasher.combine(z)
  }
}
