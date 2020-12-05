
import Foundation

enum Day05: Day {
    static func test() throws {
        precondition(try! seatId(for: "BFFFBBFRRR") == 567)
        precondition(try! seatId(for: "FFFBBBFRRR") == 119)
        precondition(try! seatId(for: "BBFFBBFRLL") == 820)
    }

    static func run(input: String) throws {
        let seatsIds = Set(try input.components(separatedBy: .newlines).map { try seatId(for: $0) })

        // Day 5-1
        print("Solution for day 5-1 is \(seatsIds.max()!)")

        // Day 5-2
        print("Solution for day 5-1 is \(try findMissing(seatsIds: seatsIds))")
    }

    static func seatId(for code: String) throws -> Int {
        // Convert to binary. B <=> 1 ; F <=> 0 ; R <=> 1 ; L <=> 0
        let binary = code
            .replacingOccurrences(of: "F", with: "0")
            .replacingOccurrences(of: "B", with: "1")
            .replacingOccurrences(of: "L", with: "0")
            .replacingOccurrences(of: "R", with: "1")
        guard let integer = Int(binary, radix: 2) else {
            throw Errors.unparsable
        }
        return integer
    }

    static func findMissing(seatsIds: Set<Int>) throws -> Int {
        for seat in seatsIds.min()!..<seatsIds.max()! {
            if !seatsIds.contains(seat) && seatsIds.contains(seat - 1) && seatsIds.contains(seat + 1) {
                return seat
            }
        }
        throw Errors.unsolvable
    }
}
