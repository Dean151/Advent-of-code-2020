
import Foundation

enum Day12: Day {
    static func test() throws {
        let input = try Input.getFromFile("\(Self.self)", file: "test")
        let instructions = try Instruction.from(input)
        precondition(instructions.count == 5)
        let position = try self.shipPosition(after: instructions)
        precondition(position.manatthanDistance == 25)
        let position2 = try self.shipAndWayPointPosition(after: instructions)
        precondition(position2.manatthanDistance == 286)
    }

    static func run(input: String) throws {
        let instructions = try Instruction.from(input)

        // Day 12-1
        let position = try self.shipPosition(after: instructions)
        print("Solution for Day 12-1 is \(position.manatthanDistance)")

        // Day 12-1
        let position2 = try self.shipAndWayPointPosition(after: instructions)
        print("Solution for Day 12-2 is \(position2.manatthanDistance)")
    }

    enum Instruction {
        case north(distance: Int)
        case south(distance: Int)
        case east(distance: Int)
        case west(distance: Int)
        case left(angle: Int)
        case right(angle: Int)
        case forward(distance: Int)

        func perform(from position: Vector2D, facing: inout Vector2D.Direction) throws -> Vector2D {
            switch self {
            case .north(distance: let value):
                return position.moved(.up, distance: value)
            case .south(distance: let value):
                return position.moved(.down, distance: value)
            case .east(distance: let value):
                return position.moved(.right, distance: value)
            case .west(distance: let value):
                return position.moved(.left, distance: value)
            case .forward(distance: let value):
                return position.moved(facing, distance: value)
            case .left(angle: let angle):
                if angle == 90 {
                    facing.turn(.left)
                } else if angle == 180 {
                    facing.turnAround()
                } else if angle == 270 {
                    facing.turn(.right)
                } else {
                    throw Errors.unsolvable
                }
            case .right(angle: let angle):
                if angle == 90 {
                    facing.turn(.right)
                } else if angle == 180 {
                    facing.turnAround()
                } else if angle == 270 {
                    facing.turn(.left)
                } else {
                    throw Errors.unsolvable
                }
            }
            return position
        }

        func perform(from position: Vector2D, waypoint: inout Vector2D) throws -> Vector2D {
            var position = position
            switch self {
            case .north(distance: let value):
                waypoint.move(.up, distance: value)
            case .south(distance: let value):
                waypoint.move(.down, distance: value)
            case .east(distance: let value):
                waypoint.move(.right, distance: value)
            case .west(distance: let value):
                waypoint.move(.left, distance: value)
            case .forward(distance: let value):
                position = position.moved(by: waypoint.multiplied(by: value))
            case .left(angle: let angle):
                if angle == 90 {
                    waypoint.rotate(.left)
                } else if angle == 180 {
                    waypoint.rotateAround()
                } else if angle == 270 {
                    waypoint.rotate(.right)
                } else {
                    throw Errors.unsolvable
                }
            case .right(angle: let angle):
                if angle == 90 {
                    waypoint.rotate(.right)
                } else if angle == 180 {
                    waypoint.rotateAround()
                } else if angle == 270 {
                    waypoint.rotate(.left)
                } else {
                    throw Errors.unsolvable
                }
            }
            return position
        }

        private static func from(line: String) throws -> Instruction {
            var line = line
            let order = line.removeFirst()
            guard let value = Int(line) else {
                throw Errors.unparsable
            }
            switch order {
            case "N":
                return .north(distance: value)
            case "S":
                return .south(distance: value)
            case "E":
                return .east(distance: value)
            case "W":
                return .west(distance: value)
            case "L":
                return .left(angle: value)
            case "R":
                return .right(angle: value)
            case "F":
                return .forward(distance: value)
            default:
                throw Errors.unparsable
            }
        }

        static func from(_ input: String) throws -> [Instruction] {
            var instructions: [Instruction] = []
            let lines = input.components(separatedBy: .newlines)
            for line in lines {
                instructions.append(try Instruction.from(line: line))
            }
            return instructions
        }
    }

    static func shipPosition(after instructions: [Instruction]) throws -> Vector2D {
        var current = Vector2D.zero
        var facing = Vector2D.Direction.right
        for instruction in instructions {
            current = try instruction.perform(from: current, facing: &facing)
        }
        return current
    }

    static func shipAndWayPointPosition(after instructions: [Instruction]) throws -> Vector2D {
        var ship: Vector2D = .zero
        var waypoint: Vector2D = .init(x: 10, y: -1)
        for instruction in instructions {
            ship = try instruction.perform(from: ship, waypoint: &waypoint)
        }
        return ship
    }
}
