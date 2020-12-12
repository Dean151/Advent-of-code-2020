
import Foundation

enum Day11: Day {
    static func test() throws {
        let input = try Input.getFromFile("\(Self.self)", file: "test")
        let seats = try Seats.from(input, limit: 10)
        precondition(seats.resolve(mode: .direct).count == 37)
        precondition(seats.resolve(mode: .indirect).count == 26)
    }

    static func run(input: String) throws {
        let seats = try Seats.from(input, limit: 95)

        // Day 11-1
        let occupied = seats.resolve(mode: .direct).count
        print("Solution for Day 11-1 is \(occupied)")

        // Day 11-2
        let occupied2 = seats.resolve(mode: .indirect).count
        print("Solution for Day 11-2 is \(occupied2)")
    }

    struct Seats {
        enum Mode {
            case direct, indirect

            var threshold: Int {
                switch self {
                case .direct:
                    return 4
                case .indirect:
                    return 5
                }
            }
        }

        let seats: Set<Vector2D>
        let directNeighbors: [Vector2D: Set<Vector2D>]
        let indirectNeighbors: [Vector2D: Set<Vector2D>]

        func resolve(mode: Mode) -> Set<Vector2D> {
            var previous = Set<Vector2D>()
            var current = Set<Vector2D>()
            repeat {
                previous = current
                current = nextStep(from: previous, mode: mode)
            } while current != previous
            return current
        }

        func nextStep(from occupied: Set<Vector2D>, mode: Mode) -> Set<Vector2D> {
            var newOccupied = Set<Vector2D>()
            for seat in seats {
                let occupiedNeighbors: Int
                switch mode {
                case .direct:
                    occupiedNeighbors = directNeighbors[seat]!.count(where: { occupied.contains($0) })
                case .indirect:
                    occupiedNeighbors = indirectNeighbors[seat]!.count(where: { occupied.contains($0) })
                }
                if !occupied.contains(seat) && occupiedNeighbors == 0 {
                    newOccupied.insert(seat)
                } else if occupied.contains(seat) && occupiedNeighbors < mode.threshold {
                    newOccupied.insert(seat)
                }
            }
            return newOccupied
        }

        static func from(_ input: String, limit: Int) throws -> Seats {
            var seats = Set<Vector2D>()
            for (y, line) in input.components(separatedBy: .newlines).enumerated() {
                for (x, char) in line.enumerated() {
                    if char == "L" {
                        seats.insert(.init(x: x, y: y))
                    }
                }
            }

            // Calculate direct & indirect neighbors
            var direct = [Vector2D: Set<Vector2D>]()
            var indirect = [Vector2D: Set<Vector2D>]()
            let directions: [Vector2D] = [
                .init(x: -1, y: -1),
                .init(x: 0, y: -1),
                .init(x: 1, y: -1),
                .init(x: -1, y: 0),
                .init(x: 1, y: 0),
                .init(x: -1, y: 1),
                .init(x: 0, y: 1),
                .init(x: 1, y: 1)
            ]
            for seat in seats {
                // Direct is straightforward
                direct[seat] = Set(directions.map({ seat.moved(by: $0) }).filter({ seats.contains($0) }))

                // Indirect is a bit more subtle
                var neighbors = Set<Vector2D>()
                directionLoop: for direction in directions {
                    // Find in each direction with a limit
                    var pos = seat
                    repeat {
                        pos = pos.moved(by: direction)
                        if seats.contains(pos) {
                            neighbors.insert(pos)
                            continue directionLoop
                        }
                    } while pos.x >= 0 && pos.y >= 0 && pos.x < limit && pos.y < limit
                }
                indirect[seat] = neighbors
            }
            return Seats(seats: seats, directNeighbors: direct, indirectNeighbors: indirect)
        }
    }
}
