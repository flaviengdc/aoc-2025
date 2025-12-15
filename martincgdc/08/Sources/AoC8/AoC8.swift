import Foundation

@main
struct AoC8 {
    static func main() throws {
        let points = try loadPoints()

        let part1 = Solution.solvePart1(points)
        print("Part 1: \(part1)")

        let part2 = Solution.solvePart2(points)
        print("Part 2: \(part2)")
    }

    static func loadPoints() throws -> [Vec3] {
        let filepath = "example.txt"

        let contents: String = try String(contentsOfFile: filepath, encoding: String.Encoding.utf8)
        return parsePoints(contents)
    }

    static func parsePoints(_ str: String) -> [Vec3] {
        return str.split(separator: "\n").map { str in Vec3(fromString: String(str)) }
    }
}
