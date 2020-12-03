
import Foundation

enum Day03: Day {
    static func test() throws {
        let input = try Input.getFromFile("\(Self.self)", file: "test")
        let field = try Field.parse(from: input)
        precondition(field.collisions(pattern: .init(x: 1, y: 1)) == 2)
        precondition(field.collisions(pattern: .init(x: 3, y: 1)) == 7)
        precondition(field.collisions(pattern: .init(x: 5, y: 1)) == 3)
        precondition(field.collisions(pattern: .init(x: 7, y: 1)) == 4)
        precondition(field.collisions(pattern: .init(x: 1, y: 2)) == 2)
    }

    static func run(input: String) throws {
        let field = try Field.parse(from: input)

        // Day 3-1
        let collisionsPart1 = field.collisions(pattern: .init(x: 3, y: 1))
        print("Solution for day 3-1 is \(collisionsPart1)")

        // Day 3-2
        let vectorsPart2 = [
            Vector2D(x: 1, y: 1),
            Vector2D(x: 3, y: 1),
            Vector2D(x: 5, y: 1),
            Vector2D(x: 7, y: 1),
            Vector2D(x: 1, y: 2),
        ]
        let collisionsPart2 = vectorsPart2.map { field.collisions(pattern: $0) }
        let resultPart2 = collisionsPart2.reduce(1, *)
        print("Solution for day 3-1 is \(resultPart2)")
    }

    private struct Field {
        let width: Int
        let height: Int
        let trees: Set<Vector2D>

        static func parse(from input: String) throws -> Field {
            let rows = input.components(separatedBy: .newlines)
            guard rows.count > 0 else {
                throw Errors.unparsable
            }
            let height = rows.count
            let width = rows[0].count
            var trees: Set<Vector2D> = []
            for (y, row) in rows.enumerated() {
                for (x, char) in row.enumerated() where char == "#" {
                    trees.insert(.init(x: x, y: y))
                }
            }
            return Field(width: width, height: height, trees: trees)
        }

        func collisions(pattern: Vector2D) -> Int {
            var collisions = 0
            var position: Vector2D = .zero
            while position.y < height {
                position.move(by: pattern)
                // We have a repetition on the x axis. So we use a modulo
                collisions += trees.contains(Vector2D(x: position.x % width, y: position.y)) ? 1 : 0
            }
            return collisions
        }
    }
}
